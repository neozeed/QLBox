/* QLBox host-file backend. Flat host directory; guest-visible names <=36 bytes.
 * Host I/O is invoked only by the ROM device's MMIO request, never by PC traps. */
#define _POSIX_C_SOURCE 200809L
#include "hostfs.h"
#include "imagefs.h"
#include "ql.h"
#include "builtin_files.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <sys/stat.h>
#include <fcntl.h>
#ifdef _WIN32
#include <windows.h>
#include <io.h>
#include <direct.h>
#define mkdir1(p) _mkdir(p)
#define fdopen _fdopen
#define open _open
#define close _close
#define fileno _fileno
#else
#include <dirent.h>
#include <unistd.h>
#define mkdir1(p) mkdir(p, 0700)
#endif
#ifndef O_BINARY
#define O_BINARY 0
#endif
#define SLOTS 64
#define PATHCAP 4096
/* QDOS status names: not found, exists, in use, EOF, bad name/parameter,
 * read-only, file error, not implemented, out of memory and buffer overflow. */
#define NF -7
#define EX -8
#define IU -9
#define EF -10
#define BN -12
#define BP -15
#define RO -20
#define FE -16
#define NI -19
#define OM -3
#define BO -5
/* QDOS error -1 means asynchronous retry, so disk errors never return it. */
/* One host-side resource. Guest channel blocks store a one-based index into
 * handles, not a native pointer. Buffered directories/image data use dir. */
typedef struct {
    FILE *f;
    unsigned char *dir;
    size_t dirlen;
    uint32_t pos;
    int mode, used, drive, image;
    char name[37];
    unsigned char header[64];
} Handle;
static Handle handles[SLOTS];
static char roots[8][PATHCAP];
static ImageFS *images[8];
static char *rootpath = roots[0];
static int active_drive;
/**
 * select_drive
 *
 * Select the backing directory used by the following operation. Handles retain their drive
 * number so later I/O can restore this context.
 */
static void select_drive(int d) {
    active_drive = d;
    rootpath = roots[d];
}

static int mounted;
static unsigned operations;
/**
 * get16
 *
 * Read a big-endian 16-bit guest value without host alignment or byte-order assumptions.
 */
static unsigned get16(const unsigned char *p) {
    return ((unsigned)p[0] << 8) | p[1];
}
/**
 * get32
 *
 * Read a big-endian 32-bit guest value without casting guest bytes to a host integer.
 */
static uint32_t get32(const unsigned char *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3];
}
/**
 * put16
 *
 * Store the low 16 bits of a value in big-endian guest byte order.
 */
static void put16(unsigned char *p, unsigned v) {
    p[0] = (unsigned char)(v >> 8);
    p[1] = (unsigned char)v;
}
/**
 * put32
 *
 * Store a 32-bit value in big-endian guest byte order.
 */
static void put32(unsigned char *p, uint32_t v) {
    p[0] = (unsigned char)(v >> 24);
    p[1] = (unsigned char)(v >> 16);
    p[2] = (unsigned char)(v >> 8);
    p[3] = (unsigned char)v;
}
/**
 * ram
 *
 * Return whether the entire guest byte range lies inside configured writable RAM. Subtraction
 * avoids an overflowing end address.
 */
static int ram(uint32_t a, uint32_t n) {
    return a >= 0x20000 && a <= ql.ram_top && n <= ql.ram_top - a;
}
/**
 * readable
 *
 * Accept a byte range wholly inside the main ROM or configured RAM; reject I/O and unmapped
 * ranges.
 */
static int readable(uint32_t a, uint32_t n) {
    return (a <= ql.rom_size && n <= ql.rom_size - a) || ram(a, n);
}
/**
 * lower
 *
 * Fold ASCII uppercase letters for guest filename matching, independently of the host locale.
 */
static int lower(int c) {
    return c >= 'A' && c <= 'Z' ? c + 32 : c;
}
/**
 * equal
 *
 * Compare complete guest names using ASCII case folding. Dots and underscores remain distinct.
 */
static int equal(const char *a, const char *b) {
    while (*a && *b)
        if (lower(*a++) != lower(*b++))
            return 0;
    return *a == *b;
}
/**
 * prefix
 *
 * Test a case-insensitive ASCII prefix, used for device names and directory filtering.
 */
static int prefix(const char *a, const char *b) {
    while (*b)
        if (lower(*a++) != lower(*b++))
            return 0;
    return 1;
}
/**
 * valid
 *
 * Validate the flat host-drive filename contract, including length, forbidden path characters
 * and reserved device stems. empty controls whether an empty directory name is allowed.
 */
static int valid(const char *s, int empty) {
    size_t n = strlen(s), i;
    char stem[5] = {0};
    if (!n)
        return empty;
    if (n > 36 || s[0] == '.' || s[n - 1] == ' ' || s[n - 1] == '.')
        return 0;
    for (i = 0; i < n; i++)
        if ((unsigned char)s[i] < 32 || (unsigned char)s[i] > 126 || strchr("/\\:*?\"<>|", s[i]))
            return 0;
    for (i = 0; i < 4 && s[i] && s[i] != '.'; i++)
        stem[i] = (char)lower(s[i]);
    if (equal(stem, "con") || equal(stem, "prn") || equal(stem, "aux") || equal(stem, "nul"))
        return 0;
    if ((prefix(stem, "com") || prefix(stem, "lpt")) && stem[3] >= '1' && stem[3] <= '9')
        return 0;
    return 1;
}
/**
 * path
 *
 * Join the selected root and an already validated filename into PATHCAP bytes. Return false if
 * the result would be truncated.
 */
static int path(char *out, const char *name) {
    return snprintf(out, PATHCAP, "%s/%s", rootpath, name) < PATHCAP;
}
/**
 * regular
 *
 * Accept only supported regular host files with a representable QDOS length; reject
 * symlinks/reparse points and directories.
 */
static int regular(const char *name) {
    char p[PATHCAP];
    struct stat st;
    if (!path(p, name))
        return 0;
#ifdef _WIN32
    {
        DWORD a = GetFileAttributesA(p);
        if (a == INVALID_FILE_ATTRIBUTES ||
            (a & (FILE_ATTRIBUTE_DIRECTORY | FILE_ATTRIBUTE_REPARSE_POINT)))
            return 0;
    }
    if (stat(p, &st))
        return 0;
#else
    if (lstat(p, &st) || !S_ISREG(st.st_mode))
        return 0;
#endif
    return st.st_size >= 0 && (uint64_t)st.st_size <= 0x7fffffbfu;
}
typedef struct {
    char (*names)[37];
    size_t count;
    int error;
} Names;
/**
 * addname
 *
 * Append a validated regular filename to a temporary directory snapshot; record
 * allocation/entry-limit failure in the snapshot.
 */
static void addname(Names *n, const char *s) {
    void *p;
    if (!valid(s, 0) || !regular(s))
        return;
    if (n->count >= 32768) {
        n->error = OM;
        return;
    }
    p = realloc(n->names, (n->count + 1) * 37);
    if (!p) {
        n->error = OM;
        return;
    }
    n->names = p;
    strcpy(n->names[n->count++], s);
}
/**
 * namecmp
 *
 * Provide case-insensitive ASCII ordering for qsort; this also puts conflicting case variants
 * next to one another.
 */
static int namecmp(const void *aa, const void *bb) {
    const char *a = aa, *b = bb;
    while (*a && lower(*a) == lower(*b)) {
        a++;
        b++;
    }
    return lower(*a) - lower(*b);
}
/**
 * names
 *
 * Enumerate the selected host directory, sort eligible files and reject ambiguous case-
 * insensitive duplicates. The caller frees names even on error.
 */
static int names(Names *n) {
    memset(n, 0, sizeof(*n));
#ifdef _WIN32
    {
        WIN32_FIND_DATAA data;
        HANDLE f;
        char p[PATHCAP];
        if (!path(p, "*"))
            return BN;
        f = FindFirstFileA(p, &data);
        if (f == INVALID_HANDLE_VALUE)
            return NF;
        do {
            addname(n, data.cFileName);
        } while (!n->error && FindNextFileA(f, &data));
        FindClose(f);
    }
#else
    {
        DIR *d = opendir(rootpath);
        struct dirent *e;
        if (!d)
            return NF;
        while (!n->error && (e = readdir(d)))
            addname(n, e->d_name);
        closedir(d);
    }
#endif
    if (n->count)
        qsort(n->names, n->count, 37, namecmp);
    {
        size_t i;
        for (i = 1; i < n->count; i++)
            if (equal(n->names[i - 1], n->names[i]))
                n->error = BN;
    }
    return n->error;
}
/**
 * resolve
 *
 * Resolve a guest name to its actual host spelling. Return a QDOS status separately from exists
 * so a missing file can still be created.
 */
static int resolve(char name[37], int *exists) {
    Names n;
    size_t i;
    int e = names(&n);
    *exists = 0;
    if (!e)
        for (i = 0; i < n.count; i++)
            if (equal(name, n.names[i])) {
                strcpy(name, n.names[i]);
                *exists = 1;
                break;
            }
    free(n.names);
    return e;
}
/**
 * meta_path
 *
 * Build the sidecar header path by hex-encoding the case-folded filename; metadata filenames
 * cannot introduce path separators.
 */
static int meta_path(char *out, const char *name) {
    char hex[73];
    size_t i;
    for (i = 0; name[i]; i++)
        sprintf(hex + 2 * i, "%02x", (unsigned char)lower(name[i]));
    hex[2 * i] = 0;
    return snprintf(out, PATHCAP, "%s/.qlbox-meta/%s.hdr", rootpath, hex) < PATHCAP;
}
/**
 * meta_directory
 *
 * Validate the metadata directory, creating it only when requested. Return a QDOS error if it is
 * missing or unsuitable.
 */
static int meta_directory(int create) {
    char p[PATHCAP];
    struct stat st;
    if (!path(p, ".qlbox-meta"))
        return BN;
#ifdef _WIN32
    {
        DWORD a = GetFileAttributesA(p);
        if (a != INVALID_FILE_ATTRIBUTES &&
            ((a & FILE_ATTRIBUTE_REPARSE_POINT) || !(a & FILE_ATTRIBUTE_DIRECTORY)))
            return BN;
    }
#else
    if (!lstat(p, &st) && !S_ISDIR(st.st_mode))
        return BN;
#endif
    if (stat(p, &st) == 0)
        return 0;
    if (!create)
        return NF;
    return mkdir1(p) == 0 ? 0 : FE;
}
/**
 * meta_regular
 *
 * Reject an existing metadata path that is not a safe regular file; a missing path remains
 * acceptable for creation.
 */
static int meta_regular(const char *p) {
    struct stat st;
#ifdef _WIN32
    DWORD a = GetFileAttributesA(p);
    if (a == INVALID_FILE_ATTRIBUTES)
        return 1;
    if (a & (FILE_ATTRIBUTE_DIRECTORY | FILE_ATTRIBUTE_REPARSE_POINT))
        return 0;
#else
    if (lstat(p, &st))
        return errno == ENOENT;
    if (!S_ISREG(st.st_mode))
        return 0;
#endif
    (void)st;
    return 1;
}
/**
 * header_load
 *
 * Construct the 64-byte QDOS header. Explicit sidecar metadata takes precedence over an XTcc
 * executable trailer; payload size and filename come from the current host file.
 */
static int header_load(const char *name, unsigned char h[64]) {
    char p[PATHCAP];
    FILE *f;
    struct stat st;
    int explicit_header = 0;
    memset(h, 0, 64);
    if (meta_directory(0) == 0 && meta_path(p, name)) {
        if (!meta_regular(p))
            return BN;
        f = fopen(p, "rb");
        if (f) {
            size_t n = fread(h, 1, 64, f);
            fclose(f);
            if (n != 64)
                return FE;
            explicit_header = 1;
        }
    }
    if (!path(p, name) || stat(p, &st))
        return NF;
    /* XTcc is an EOF trailer, not an in-file signature scan. Explicit
  * metadata (including type 0) always wins. Keep all payload bytes intact. */
    if (!explicit_header && st.st_size >= 8 && (uint64_t)st.st_size <= 0x7fffffbfu) {
        unsigned char tail[8];
        uint32_t space;
        f = fopen(p, "rb");
        if (!f)
            return FE;
        if (fseek(f, -8, SEEK_END) || fread(tail, 1, 8, f) != 8) {
            fclose(f);
            return FE;
        }
        fclose(f);
        space = get32(tail + 4);
        if (!memcmp(tail, "XTcc", 4) && space <= 0x7fffffbfu - (uint32_t)st.st_size) {
            h[5] = 1;
            put32(h + 6, space);
        }
    }
    put32(h, (uint32_t)st.st_size);
    put16(h + 14, (unsigned)strlen(name));
    memset(h + 16, 0, 36);
    memcpy(h + 16, name, strlen(name));
    return 0;
}
/**
 * header_save
 *
 * Persist the handle header to its metadata sidecar. Return zero on success or a QDOS error;
 * payload bytes are stored separately.
 */
static int header_save(Handle *h) {
    char p[PATHCAP];
    FILE *f;
    int e = meta_directory(1), ok;
    if (e)
        return e;
    if (!meta_path(p, h->name) || !meta_regular(p))
        return BN;
    f = fopen(p, "wb");
    if (!f)
        return FE;
    ok = fwrite(h->header, 1, 64, f) == 64;
    return fclose(f) == 0 && ok ? 0 : FE;
}
/**
 * size_file
 *
 * Obtain the current payload length for a stream or buffered directory and reject values outside
 * the supported QDOS range.
 */
static int size_file(Handle *h, uint32_t *size) {
    long n;
    if (h->dir) {
        *size = (uint32_t)h->dirlen;
        return 0;
    }
    if (fseek(h->f, 0, SEEK_END) || (n = ftell(h->f)) < 0)
        return FE;
    if ((unsigned long)n > 0x7fffffbfu)
        return FE;
    *size = (uint32_t)n;
    return 0;
}
/* Parse a QDOS length-prefixed name. BOOT aliases WIN1_BOOT only for open. */
/**
 * guest_name
 *
 * Decode a counted guest name, select its mount slot and validate the remaining filename.
 * Recognize ROM1 separately and allow the boot-only BOOT alias.
 */
static int guest_name(uint32_t ptr, char out[37], int boot, int *builtin) {
    unsigned n, skip = 0;
    char full[44];
    *builtin = 0;
    select_drive(0);
    if (!readable(ptr, 2))
        return BP;
    n = get16(ql.mem + ptr);
    if (n >= sizeof(full) || !readable(ptr + 2, n))
        return BN;
    memcpy(full, ql.mem + ptr + 2, n);
    full[n] = 0;
    if (strlen(full) != n)
        return BN;
    if (boot && equal(full, "BOOT")) {
        strcpy(out, "BOOT");
        return 0;
    }
    if ((prefix(full, "WIN") || prefix(full, "FLP") || prefix(full, "MDV")) && full[3] >= '1' &&
        full[3] <= '8' && full[4] == '_') {
        skip = 5;
        select_drive(full[3] - '1');
    } else if (prefix(full, "HOST") && full[4] >= '1' && full[4] <= '8' && full[5] == '_') {
        skip = 6;
        select_drive(full[4] - '1');
    } else if (prefix(full, "ROM1_")) {
        skip = 5;
        *builtin = 1;
    } else
        return NI;
    if (!valid(full + skip, 1))
        return BN;
    strcpy(out, full + skip);
    return 0;
}
/**
 * busy
 *
 * Check open handles on the selected drive for conflicting access. Multiple read-only opens may
 * coexist.
 */
static int busy(const char *name, int mode) {
    unsigned i;
    for (i = 0; i < SLOTS; i++)
        if (handles[i].used && handles[i].drive == active_drive && !handles[i].dir &&
            equal(handles[i].name, name)) {
            if (mode != 1 || handles[i].mode != 1)
                return 1;
        }
    return 0;
}
/**
 * builtin_header
 *
 * Synthesize a QDOS header from an embedded utility entry, including its executable type and
 * dataspace.
 */
static void builtin_header(unsigned char *out, const BuiltinFile *f) {
    memset(out, 0, 64);
    put32(out, f->size);
    out[5] = (unsigned char)f->type;
    put32(out + 6, f->dataspace);
    put16(out + 14, (unsigned)strlen(f->name));
    memcpy(out + 16, f->name, strlen(f->name));
}
/**
 * builtin_open
 *
 * Open an embedded utility or construct a ROM1 directory stream. Allocate a normal host handle
 * but reject creation and writes.
 */
static int builtin_open(const char *name, int mode, uint32_t *id) {
    unsigned i, j;
    size_t count = 0;
    Handle *h;
    if (mode < 0 || mode > 4)
        return BP;
    if (mode == 2 || mode == 3)
        return RO;
    for (i = 0; i < SLOTS && handles[i].used; i++) {
    }
    if (i == SLOTS)
        return OM;
    h = &handles[i];
    memset(h, 0, sizeof(*h));
    h->mode = 1;
    if (mode == 4 || !*name) {
        h->dir = calloc(BUILTIN_COUNT + 1, 64);
        if (!h->dir)
            return OM;
        for (j = 0; j < BUILTIN_COUNT; j++)
            if (prefix(builtin_files[j].name, name)) {
                unsigned char *entry = h->dir + count++ * 64;
                builtin_header(entry, &builtin_files[j]);
                put32(entry, get32(entry) + 64);
            }
        h->dirlen = count * 64;
        h->header[5] = 255;
    } else {
        for (j = 0; j < BUILTIN_COUNT && !equal(name, builtin_files[j].name); j++) {
        }
        if (j == BUILTIN_COUNT)
            return NF;
        h->dir = malloc(builtin_files[j].size + 1);
        if (!h->dir)
            return OM;
        memcpy(h->dir, builtin_files[j].data, builtin_files[j].size);
        h->dirlen = builtin_files[j].size;
        builtin_header(h->header, &builtin_files[j]);
    }
    h->used = 1;
    *id = i + 1;
    return 0;
}
/* Image handles reuse the bounded, read-only memory-file I/O path. */
/**
 * image_open
 *
 * Open a file or directory view from an already decoded image, using the same handle interface
 * as host files while preserving read-only semantics.
 */
static int image_open(const char *name, int mode, uint32_t *id) {
    ImageFS *fs = images[active_drive];
    Handle *h;
    unsigned i;
    size_t j, count = 0;
    const ImageFile *file = NULL;
    if (mode < 0 || mode > 4)
        return BP;
    if (mode == 2 || mode == 3)
        return RO;
    for (i = 0; i < SLOTS && handles[i].used; i++) {
    }
    if (i == SLOTS)
        return OM;
    for (j = 0; j < fs->count; j++)
        if (equal(fs->files[j].name, name)) {
            file = &fs->files[j];
            break;
        }
    h = &handles[i];
    memset(h, 0, sizeof(*h));
    h->mode = 1;
    h->drive = active_drive;
    h->image = 1;
    if (mode == 4 || !*name || (file && file->header[5] == 255)) {
        h->dir = calloc(fs->count + 1, 64);
        if (!h->dir)
            return OM;
        for (j = 0; j < fs->count; j++)
            if (prefix(fs->files[j].name, name) && !equal(fs->files[j].name, name)) {
                unsigned char *entry = h->dir + count++ * 64;
                memcpy(entry, fs->files[j].header, 64);
                put32(entry, fs->files[j].size + 64);
            }
        h->dirlen = count * 64;
        h->header[5] = 255;
        put16(h->header + 14, (unsigned)strlen(name));
        memcpy(h->header + 16, name, strlen(name));
    } else {
        if (!file)
            return NF;
        h->dir = malloc((size_t)file->size + 1);
        if (!h->dir)
            return OM;
        memcpy(h->dir, file->data, file->size);
        h->dirlen = file->size;
        memcpy(h->header, file->header, 64);
    }
    strcpy(h->name, name);
    h->used = 1;
    *id = i + 1;
    return 0;
}
/**
 * open_file
 *
 * Validate and resolve an open request, dispatch ROM1/image mounts, or open/create a host
 * payload and its header. Return the allocated handle ID through id.
 */
static int open_file(uint32_t addr, int mode, uint32_t *id) {
    Handle *h;
    char name[37], p[PATHCAP];
    int e, exists = 0, builtin;
    unsigned i;
    e = guest_name(addr, name, 1, &builtin);
    if (e)
        return e == NI ? NF : e;
    if (builtin)
        return builtin_open(name, mode, id);
    if (images[active_drive])
        return image_open(name, mode, id);
    if (!rootpath[0])
        return NF;
    if (mode < 0 || mode > 4)
        return BP;
    if (!name[0] && mode != 4 && mode != 0 && mode != 1)
        return BN;
    for (i = 0; i < SLOTS && handles[i].used; i++) {
    }
    if (i == SLOTS)
        return OM;
    h = &handles[i];
    memset(h, 0, sizeof(*h));
    h->mode = mode;
    h->drive = active_drive;
    if (mode == 4 || !name[0]) {
        Names n;
        size_t j, count = 0;
        e = names(&n);
        if (e) {
            free(n.names);
            return e;
        }
        h->dir = calloc(n.count + 1, 64);
        if (!h->dir) {
            free(n.names);
            return OM;
        }
        for (j = 0; j < n.count; j++)
            if (prefix(n.names[j], name)) {
                unsigned char *entry = h->dir + count * 64;
                e = header_load(n.names[j], entry);
                if (e)
                    break;
                put32(entry, get32(entry) + 64);
                count++;
            }
        free(n.names);
        if (e) {
            free(h->dir);
            h->dir = NULL;
            return e;
        }
        h->dirlen = count * 64;
        h->header[5] = 255;
        put16(h->header + 14, (unsigned)strlen(name));
        memcpy(h->header + 16, name, strlen(name));
    } else {
        e = resolve(name, &exists);
        if (e)
            return e;
        if (busy(name, mode))
            return IU;
        if (mode == 2 && exists)
            return EX;
        if (mode < 2 && !exists)
            return NF;
        if (!path(p, name))
            return BN;
        /* Reject an existing non-regular entry instead of opening a device/link. */
        {
            struct stat st;
            if (!exists && !stat(p, &st))
                return BN;
        }
        if (mode == 2 || (mode == 3 && !exists)) {
            int fd = open(p, O_RDWR | O_CREAT | O_EXCL | O_BINARY, 0600);
            if (fd < 0)
                return errno == EEXIST ? EX : FE;
            h->f = fdopen(fd, "w+b");
            if (!h->f) {
                close(fd);
                return FE;
            }
        } else
            h->f = fopen(p, mode == 1 ? "rb" : mode == 3 ? "w+b" : "r+b");
        if (!h->f)
            return errno == EACCES ? RO : FE;
        strcpy(h->name, name);
        e = header_load(name, h->header);
        if (e) {
            fclose(h->f);
            h->f = NULL;
            return e;
        }
        if (mode >= 2) {
            memset(h->header, 0, 14);
            e = header_save(h);
            if (e) {
                fclose(h->f);
                h->f = NULL;
                return e;
            }
        }
    }
    h->used = 1;
    *id = i + 1;
    return 0;
}
/**
 * close_file
 *
 * Flush writable payload/header state, close the host stream and free buffered directory data.
 * Invalidate the handle even if finalization reports an error.
 */
static int close_file(unsigned id) {
    Handle *h;
    int e = 0;
    if (!id || id > SLOTS || !handles[id - 1].used)
        return BP;
    h = &handles[id - 1];
    select_drive(h->drive);
    if (h->f) {
        if (h->mode != 1) {
            uint32_t size;
            if (fflush(h->f) || size_file(h, &size))
                e = FE;
            else {
                put32(h->header, size);
                e = header_save(h);
            }
        }
        if (fclose(h->f))
            e = FE;
    }
    free(h->dir);
    memset(h, 0, sizeof(*h));
    return e;
}
/**
 * delete_file
 *
 * Delete a validated, non-busy host file and its sidecar. Embedded utilities and mounted images
 * reject deletion.
 */
static int delete_file(uint32_t ptr) {
    char name[37], p[PATHCAP];
    int e, exists, builtin;
    e = guest_name(ptr, name, 0, &builtin);
    if (e)
        return e;
    if (builtin || images[active_drive])
        return RO;
    if (!rootpath[0])
        return NF;
    if (!name[0])
        return BN;
    e = resolve(name, &exists);
    if (e)
        return e;
    if (!exists)
        return NF;
    if (busy(name, 0))
        return IU;
    if (!path(p, name) || remove(p))
        return FE;
    if (meta_directory(0) == 0 && meta_path(p, name) && meta_regular(p))
        remove(p);
    return 0;
}
/**
 * transfer
 *
 * Perform byte, line or block I/O for a handle. Update the guest pointer, byte count and file
 * position, returning QDOS EOF or buffer-full status where appropriate.
 */
static int transfer(Handle *h, unsigned op, uint32_t *d1, uint32_t count, uint32_t *a1) {
    uint32_t i = 0;
    int c = 0, line = op == 2, writing = op == 5 || op == 7 || op == 0x49;
    if (op == 1 || op == 5)
        count = 1;
    if (count > 0x7fffffbfu)
        return BP;
    if (op != 1 && op != 5 && !(writing ? readable(*a1, count) : ram(*a1, count)))
        return BP;
    if (writing && (h->mode == 1 || h->dir))
        return RO;
    if (!h->dir && fseek(h->f, (long)h->pos, SEEK_SET))
        return FE;
    if (!line && op != 1 && op != 5) {
        size_t n;
        if (h->dir) {
            n = h->pos < h->dirlen ? h->dirlen - h->pos : 0;
            if (n > count)
                n = count;
            if (n)
                memcpy(ql.mem + *a1, h->dir + h->pos, n);
        } else if (writing)
            n = fwrite(ql.mem + *a1, 1, count, h->f);
        else
            n = fread(ql.mem + *a1, 1, count, h->f);
        h->pos += (uint32_t)n;
        *a1 += (uint32_t)n;
        *d1 = (uint32_t)n;
        if (n < count)
            return h->f && ferror(h->f) ? FE : writing ? FE : EF;
        return 0;
    }
    while (i < count) {
        if (writing) {
            c = fputc((int)(*d1 & 255), h->f);
            if (c == EOF)
                break;
        } else if (h->dir)
            c = h->pos < h->dirlen ? h->dir[h->pos] : EOF;
        else
            c = fgetc(h->f);
        if (c == EOF)
            break;
        h->pos++;
        i++;
        if (op == 1)
            *d1 = (*d1 & 0xffffff00u) | (unsigned)c;
        else if (!writing)
            ql.mem[(*a1)++] = (unsigned char)c;
        if (line && c == 10)
            break;
    }
    if (op != 1 && op != 5)
        *d1 = i;
    if (c == EOF)
        return h->f && ferror(h->f) ? FE : writing ? FE : EF;
    if (line && (i == count) && (c != 10))
        return BO;
    return 0;
}
/**
 * io_file
 *
 * Dispatch a QDOS I/O opcode using the six-long request block. Implements transfers,
 * positioning, headers and file-management operations; unsupported operations return NI.
 */
static int io_file(uint32_t *r) {
    unsigned id, op = r[0];
    Handle *h;
    uint32_t size, n;
    int e;
    if (!ram(r[4], 32))
        return BP;
    id = get32(ql.mem + r[4] + 24);
    if (!id || id > SLOTS || !handles[id - 1].used)
        return BP;
    h = &handles[id - 1];
    select_drive(h->drive);
    if (!h->dir && !h->f)
        return FE;
    switch (op) {
    case 0:
        e = size_file(h, &size);
        return e ? e : h->pos < size ? 0 : EF;
    case 1:
    case 2:
    case 3:
    case 5:
    case 7:
    case 0x48:
    case 0x49:
        n = op < 0x40 ? (r[2] & 65535) : r[2];
        return transfer(h, op, &r[1], n, &r[5]);
    case 0x40:
    case 0x41:
        return h->f && h->mode != 1 && fflush(h->f) ? FE : 0;
    case 0x42:
    case 0x43: {
        int64_t pos = (int32_t)r[1];
        if (op == 0x43)
            pos += h->pos;
        e = size_file(h, &size);
        if (e)
            return e;
        if (pos < 0)
            pos = 0;
        if (pos > size) {
            pos = size;
            e = EF;
        }
        h->pos = r[1] = (uint32_t)pos;
        return e;
    }
    case 0x45:
        if (!ram(r[5], 10))
            return BP;
        memcpy(ql.mem + r[5], h->image ? images[h->drive]->label : "QLBOX HOST", 10);
        r[5] += 10;
        r[1] = 0x7fff7fff;
        return 0; /* virtual sector counts, not host capacity */
    case 0x46:
        if (h->mode == 1 || h->dir)
            return RO;
        if (!ram(r[5], 14))
            return BP;
        memcpy(h->header + 4, ql.mem + r[5] + 4, 10);
        return header_save(h);
    case 0x47:
        n = r[2] & 65535;
        if (n > 64)
            return BP;
        if (!ram(r[5], n))
            return BP;
        e = size_file(h, &size);
        if (e)
            return e;
        put32(h->header, size);
        memcpy(ql.mem + r[5], h->header, n);
        r[5] += n;
        r[1] = n;
        return 0;
    case 0x4a: {
        char name[37], old[PATHCAP], dest[PATHCAP], meta[PATHCAP];
        int exists, builtin;
        if (h->mode == 1 || h->dir)
            return RO;
        e = guest_name(r[5], name, 0, &builtin);
        if (e)
            return e == NI ? BN : e;
        if (builtin || active_drive != h->drive) {
            select_drive(h->drive);
            return RO;
        }
        if (!name[0])
            return BN;
        e = resolve(name, &exists);
        if (e)
            return e;
        if (equal(name, h->name))
            return 0;
        if (exists)
            return EX;
        if (!path(old, h->name) || !path(dest, name))
            return BN;
        /* Windows forbids renaming an open CRT stream. Preserve the handle state. */
        if (fflush(h->f))
            return FE;
        if (fclose(h->f)) {
            h->f = NULL;
            return FE;
        }
        h->f = NULL;
        if (rename(old, dest)) {
            h->f = fopen(old, "r+b");
            return FE;
        }
        if (meta_directory(0) == 0 && meta_path(meta, h->name) && meta_regular(meta))
            remove(meta);
        strcpy(h->name, name);
        put16(h->header + 14, (unsigned)strlen(name));
        memset(h->header + 16, 0, 36);
        memcpy(h->header + 16, name, strlen(name));
        h->f = fopen(dest, "r+b");
        if (!h->f)
            return FE;
        return header_save(h);
    }
    case 0x4b:
        if (h->mode == 1 || h->dir)
            return RO;
        if (fflush(h->f))
            return FE;
#ifdef _WIN32
        if (_chsize(fileno(h->f), (long)h->pos))
            return FE;
#else
        if (ftruncate(fileno(h->f), (off_t)h->pos))
            return FE;
#endif
        put32(h->header, h->pos);
        return header_save(h);
    default:
        return NI;
    }
}
/**
 * hostfs_init
 *
 * Reset the handle/mount state and install the initial slot-1 mount. Return false if it cannot
 * be mounted.
 */
int hostfs_init(const char *root) {
    hostfs_shutdown();
    operations = 0;
    mounted = 0;
    if (!root)
        return 1;
    if (!hostfs_mount(1, root)) {
        fprintf(stderr, "Cannot mount directory or QL image: %s\n", root);
        return 0;
    }
    select_drive(0);
    mounted = 1;
    return 1;
}
/**
 * hostfs_shutdown
 *
 * Close all live handles and release decoded image allocations for every mount slot.
 */
void hostfs_shutdown(void) {
    unsigned i;
    for (i = 0; i < SLOTS; i++)
        if (handles[i].used)
            close_file(i + 1);
    for (i = 0; i < 8; i++) {
        imagefs_free(images[i]);
        images[i] = NULL;
    }
    mounted = 0;
    memset(roots, 0, sizeof(roots));
    select_drive(0);
}
/**
 * hostfs_mount
 *
 * Install a host directory or supported read-only image in one of eight slots. Reject replacing
 * a drive with open handles.
 */
int hostfs_mount(unsigned drive, const char *root) {
    struct stat st;
    ImageFS *image = NULL;
    unsigned i;
    if (drive < 1 || drive > 8 || !root || strlen(root) > PATHCAP - 100 || stat(root, &st))
        return 0;
    /* Remounts must not invalidate an open handle. */
    for (i = 0; i < SLOTS; i++)
        if (handles[i].used && handles[i].drive == (int)drive - 1)
            return 0;
    if (S_ISREG(st.st_mode)) {
        image = imagefs_load(root);
        if (!image)
            return 0;
    } else if (!S_ISDIR(st.st_mode))
        return 0;
    imagefs_free(images[drive - 1]);
    images[drive - 1] = image;
    strcpy(roots[drive - 1], root);
    return 1;
}
/**
 * hostfs_command
 *
 * Read the ROM bridge request from guest RAM, dispatch open/I/O/close/delete and write the
 * updated register block back. Optional trace output reports errors and early operations.
 */
void hostfs_command(unsigned command, uint32_t request) {
    uint32_t r[6];
    unsigned i;
    int e = BP;
    if (!ram(request, 24))
        return;
    for (i = 0; i < 6; i++)
        r[i] = get32(ql.mem + request + i * 4);
    if (command == 1)
        e = open_file(r[4], (int)(r[3] & 255), &r[1]);
    if (command == 2)
        e = io_file(r);
    if (command == 3)
        e = close_file(r[1]);
    if (command == 4)
        e = delete_file(r[4]);
    if (ql.trace && (operations++ < 100 || e))
        fprintf(stderr, "[hostfs] cmd=%u op=%02x status=%d d1=%u a1=%06x\n", command, r[0], e, r[1],
                r[5]);
    r[0] = (uint32_t)e;
    for (i = 0; i < 6; i++)
        put32(ql.mem + request + i * 4, r[i]);
}
