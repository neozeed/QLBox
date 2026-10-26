/* QDOS filesystem reader. QL5A physical sector images, QL5B logical images,
 * QLWA linked allocation units. Directory lengths include a 64-byte header.
 * Format references: QDOS/SMS reference manual section 8; QLAY qlt-flp/qxl.
 * No host paths are constructed from guest filenames. */
#include "imagefs.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LIMIT (128u * 1024u * 1024u)
/* Temporary decoder state. used marks allocations already claimed so malformed
 * images cannot silently reuse sectors or create allocation-chain cycles. */
typedef struct {
    unsigned char *disk, *logical, *used;
    size_t size;
    unsigned blocks, unit;
    ImageFS *fs;
} Reader;
/**
 * u16
 *
 * Read a big-endian 16-bit guest value without host alignment or byte-order assumptions.
 */
static unsigned u16(const unsigned char *p) {
    return (unsigned)p[0] * 256 + p[1];
}
/**
 * u32
 *
 * Read a big-endian 32-bit guest value without casting guest bytes to a host integer.
 */
static uint32_t u32(const unsigned char *p) {
    return (uint32_t)u16(p) * 65536 + u16(p + 2);
}
/**
 * p32
 *
 * Store a 32-bit value in big-endian guest byte order.
 */
static void p32(unsigned char *p, uint32_t n) {
    p[0] = n >> 24;
    p[1] = n >> 16;
    p[2] = n >> 8;
    p[3] = n;
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
 * same
 *
 * Compare complete image filenames using ASCII case folding.
 */
static int same(const char *a, const char *b) {
    while (*a && *b)
        if (lower((unsigned char)*a++) != lower((unsigned char)*b++))
            return 0;
    return *a == *b;
}
/**
 * imagefs_free
 *
 * Release every decoded payload and the filesystem container; NULL is accepted for error-path
 * cleanup.
 */
void imagefs_free(ImageFS *fs) {
    size_t i;
    if (!fs)
        return;
    for (i = 0; i < fs->count; i++)
        free(fs->files[i].data);
    free(fs->files);
    free(fs);
}
/**
 * add
 *
 * Validate one image header and add an owned payload copy to the filesystem. Normalize length to
 * exclude the on-image 64-byte header and reject duplicate names.
 */
static int add(Reader *r, const unsigned char *h, unsigned char *raw, const char *parent) {
    unsigned n = u16(h + 14);
    uint32_t len = u32(h);
    size_t i, pn = strlen(parent);
    char name[37];
    ImageFile *f, *v;
    if (!n || n > 36 || len < 64)
        return 0;
    for (i = 0; i < n; i++)
        if (!h[16 + i] || h[16 + i] < 32)
            return 0;
    /* SMSQ directory entries normally already contain the full QDOS name. */
    if (pn && n >= pn) {
        for (i = 0; i < pn && lower(h[16 + i]) == lower((unsigned char)parent[i]); i++) {
        }
        if (i == pn)
            pn = 0;
    }
    if (pn + n > 36)
        return 0;
    memcpy(name, parent, pn);
    memcpy(name + pn, h + 16, n);
    name[pn + n] = 0;
    for (i = 0; i < r->fs->count; i++)
        if (same(name, r->fs->files[i].name))
            return 0;
    if (r->fs->count >= 32768)
        return 0;
    v = realloc(r->fs->files, (r->fs->count + 1) * sizeof(*v));
    if (!v)
        return 0;
    r->fs->files = v;
    f = &v[r->fs->count];
    memset(f, 0, sizeof(*f));
    strcpy(f->name, name);
    memcpy(f->header, h, 64);
    f->size = len - 64;
    p32(f->header, f->size);
    memset(f->header + 14, 0, 38);
    f->header[15] = (unsigned char)(pn + n);
    memcpy(f->header + 16, name, pn + n);
    f->data = malloc((size_t)f->size + 1);
    if (!f->data)
        return 0;
    memcpy(f->data, raw + 64, f->size);
    r->fs->count++;
    return 1;
}
/**
 * chain
 *
 * Copy a QLWA allocation chain into a newly allocated buffer. Track used units to reject loops,
 * shared allocations and incorrect termination; caller owns the result.
 */
static unsigned char *chain(Reader *r, unsigned start, uint32_t len) {
    unsigned char *out;
    uint32_t pos = 0;
    unsigned block = start;
    if (len < 64 || len > r->size)
        return NULL;
    out = malloc(len);
    if (!out)
        return NULL;
    while (pos < len) {
        unsigned n = len - pos, next;
        if (!block || block >= r->blocks || r->used[block]) {
            free(out);
            return NULL;
        }
        r->used[block] = 1;
        if (n > r->unit)
            n = r->unit;
        memcpy(out + pos, r->disk + (size_t)block * r->unit, n);
        pos += n;
        next = u16(r->disk + 64 + block * 2);
        if (pos == len && next != 0) {
            free(out);
            return NULL;
        }
        block = next;
    }
    return out;
}
/**
 * qlwa_dir
 *
 * Walk a QLWA directory recursively with a depth bound, reconstructing full guest names and
 * decoding each allocation chain. Return false on malformed entries.
 */
static int qlwa_dir(Reader *r, unsigned start, uint32_t len, const char *parent, unsigned depth) {
    unsigned char *dir;
    uint32_t pos;
    int ok = 0;
    if (depth > 32 || len % 64)
        return 0;
    dir = chain(r, start, len);
    if (!dir)
        return 0;
    for (pos = 64; pos < len; pos += 64) {
        const unsigned char *h = dir + pos;
        unsigned char *raw;
        uint32_t n = u32(h);
        char sub[38];
        if (!n)
            continue;
        if (h[5] == 255) {
            /* Validate/name the directory with a minimal header, then recurse. */
            unsigned char dh[64];
            size_t idx = r->fs->count;
            memcpy(dh, h, 64);
            p32(dh, 64);
            if (!add(r, dh, dh, parent))
                goto done;
            r->fs->files[idx].size = n - 64;
            p32(r->fs->files[idx].header, n - 64);
            snprintf(sub, sizeof(sub), "%s", r->fs->files[idx].name);
            if (sub[strlen(sub) - 1] != '_') {
                if (strlen(sub) >= 36)
                    goto done;
                strcat(sub, "_");
            }
            if (!qlwa_dir(r, u16(h + 58), n, sub, depth + 1))
                goto done;
        } else {
            raw = chain(r, u16(h + 58), n);
            if (!raw)
                goto done;
            ok = add(r, h, raw, parent);
            free(raw);
            if (!ok)
                goto done;
            ok = 0;
        }
    }
    ok = 1;
done:
    free(dir);
    return ok;
}
/**
 * qlwa
 *
 * Validate QLWA geometry and allocation-map bounds, reserve map units, then load the root
 * directory.
 */
static int qlwa(Reader *r) {
    unsigned root, mapblocks;
    r->unit = u16(r->disk + 4) * 512u;
    r->blocks = u16(r->disk + 42);
    if (!r->unit || !r->blocks || (uint64_t)r->unit * r->blocks != r->size ||
        64u + 2u * r->blocks > r->size)
        return 0;
    mapblocks = (64 + 2 * r->blocks + r->unit - 1) / r->unit;
    r->used = calloc(r->blocks, 1);
    if (!r->used || mapblocks >= r->blocks)
        return 0;
    memset(r->used, 1, mapblocks);
    root = u16(r->disk + 52);
    return qlwa_dir(r, root, u32(r->disk + 54), "", 0);
}
/**
 * flp_file
 *
 * Reassemble a QL5A/QL5B file by file ID and sequence number. Reject missing, duplicate or
 * shared allocation units; caller owns the returned buffer.
 */
static unsigned char *flp_file(Reader *r, unsigned id, uint32_t len) {
    unsigned char *out, *seen;
    unsigned need, i, found = 0;
    if (len < 64 || len > r->size)
        return NULL;
    need = (len + r->unit - 1) / r->unit;
    out = malloc(len);
    seen = calloc(need, 1);
    if (!out || !seen) {
        free(out);
        free(seen);
        return NULL;
    }
    for (i = 0; i < r->blocks; i++) {
        unsigned v = (unsigned)r->logical[96 + 3 * i] * 65536 + u16(r->logical + 97 + 3 * i),
                 seq = v & 4095, n;
        if ((v >> 12) != id)
            continue;
        if (seq >= need || seen[seq] || r->used[i])
            goto bad;
        seen[seq] = 1;
        r->used[i] = 1;
        found++;
        n = len - seq * r->unit;
        if (n > r->unit)
            n = r->unit;
        memcpy(out + seq * r->unit, r->logical + (size_t)i * r->unit, n);
    }
    free(seen);
    if (found == need)
        return out;
    free(out);
    return NULL;
bad:
    free(seen);
    free(out);
    return NULL;
}
/**
 * floppy
 *
 * Validate floppy geometry, convert QL5A skewed sectors to logical order, check the allocation
 * map and decode the flat directory.
 */
static int floppy(Reader *r) {
    unsigned total = u16(r->disk + 24), spt = u16(r->disk + 26), spc = u16(r->disk + 28),
             tracks = u16(r->disk + 30), alloc = u16(r->disk + 32);
    unsigned off = u16(r->disk + 38), i, j, dl = u16(r->disk + 34) * 512 + u16(r->disk + 36);
    unsigned char *dir;
    int ok = 0;
    if (!total || !spt || !spc || !tracks || !alloc || spc > 36 || (spc != spt && spc != spt * 2) ||
        total != tracks * spc || total % alloc || (size_t)total * 512 != r->size || dl % 64 ||
        u16(r->disk + 36) >= 512)
        return 0;
    if (!memcmp(r->disk, "QL5A", 4) && spc > 18)
        return 0;
    r->unit = alloc * 512;
    r->blocks = total / alloc;
    if (96 + 3 * r->blocks > r->size)
        return 0;
    r->logical = malloc(r->size);
    r->used = calloc(r->blocks, 1);
    if (!r->logical || !r->used)
        return 0;
    for (i = 0; i < total; i++) {
        unsigned physical = i;
        if (!memcmp(r->disk, "QL5A", 4)) {
            unsigned tr = i / spc, ps = r->disk[40 + i % spc];
            if ((ps & 127) >= spt || (ps >> 7) >= spc / spt)
                return 0;
            physical = tr * spc + (ps >> 7) * spt + ((ps & 127) + off * tr) % spt;
            /* The table must be a permutation, not duplicate sectors. */
            for (j = 0; j < i % spc; j++)
                if (r->disk[40 + j] == ps)
                    return 0;
        }
        memcpy(r->logical + (size_t)i * 512, r->disk + (size_t)physical * 512, 512);
    }
    /* Every sector-map allocation must describe itself in sequence. */
    for (i = 0; i < (96 + 3 * r->blocks + r->unit - 1) / r->unit; i++) {
        unsigned v = (unsigned)r->logical[96 + 3 * i] * 65536 + u16(r->logical + 97 + 3 * i);
        if (v != (0xf80000u | i))
            return 0;
        r->used[i] = 1;
    }
    dir = flp_file(r, 0, dl);
    if (!dir)
        return 0;
    for (i = 64; i < dl; i += 64) {
        unsigned char *h = dir + i, *raw;
        uint32_t n = u32(h);
        if (!n)
            continue;
        /* QL5A/B flat directory indices are allocation-map file IDs. */
        if (h[5] == 255)
            goto done;
        raw = flp_file(r, i / 64, n);
        if (!raw)
            goto done;
        ok = add(r, h, raw, "");
        free(raw);
        if (!ok)
            goto done;
        ok = 0;
    }
    ok = 1;
done:
    free(dir);
    return ok;
}
/* QLAY raw microdrive: 255 records of 686 bytes. Checksums are little-endian
 * sums seeded with $0f0f. Sector number, not tape order, indexes the map.
 * Real cartridges identify the map record as $80; QLAY-created ones use $f8.
 * Only map-allocated sectors are interpreted: free sectors may contain old data.
 */
#define MDV_RECORD 686u
/**
 * mdv_sum
 *
 * Validate a microdrive block checksum: a 16-bit sum seeded with 0x0f0f, stored little-endian
 * after the checked bytes.
 */
static int mdv_sum(const unsigned char *p, unsigned n) {
    unsigned sum = 0x0f0f, i;
    for (i = 0; i < n; i++)
        sum += p[i];
    return (sum & 65535) == ((unsigned)p[n] | ((unsigned)p[n + 1] << 8));
}
/**
 * mdv_file
 *
 * Reassemble a microdrive file from map-selected sectors, checking file IDs, sequence numbers
 * and header/data checksums.
 */
static unsigned char *mdv_file(const unsigned char **sectors, const unsigned char *map, unsigned id,
                               uint32_t len) {
    unsigned i, need, found = 0;
    unsigned char seen[255] = {0}, *raw;
    if (len < 64 || len > 255u * 512)
        return NULL;
    need = (len + 511) / 512;
    raw = malloc(len);
    if (!raw)
        return NULL;
    for (i = 0; i < 255; i++)
        if (map[2 * i] == id) {
            unsigned seq = map[2 * i + 1], n;
            const unsigned char *p = sectors[i];
            if (!p || seq >= need || seen[seq] || p[40] != id || p[41] != seq ||
                !mdv_sum(p + 40, 2) || !mdv_sum(p + 52, 512))
                goto bad;
            seen[seq] = 1;
            found++;
            n = len - seq * 512;
            if (n > 512)
                n = 512;
            memcpy(raw + seq * 512, p + 52, n);
        }
    if (found == need)
        return raw;
bad:
    free(raw);
    return NULL;
}
/**
 * microdrive
 *
 * Decode a QLAY-format cartridge by sector number rather than physical record order. Validate
 * the map, directory and every allocated file before accepting it.
 */
static int microdrive(Reader *r) {
    const unsigned char *sectors[255] = {0}, *map = NULL, *first = NULL;
    unsigned i, id, mapsn = 0;
    int ok = 0;
    unsigned char *dir = NULL;
    uint32_t len;
    if (r->size != 255u * MDV_RECORD)
        return 0;
    for (i = 0; i < 255; i++) {
        const unsigned char *p = r->disk + i * MDV_RECORD;
        unsigned sn = p[13];
        /* Unformatted/unusable records need not contain a valid sector header. */
        if (p[12] != 255)
            continue;
        if (sn >= 255 || sectors[sn] || !mdv_sum(p + 12, 14))
            return 0;
        if (first && memcmp(first + 14, p + 14, 12))
            return 0;
        first = p;
        sectors[sn] = p;
        if ((p[40] == 128 || p[40] == 248) && p[41] == 0) {
            if (map || !mdv_sum(p + 40, 2) || !mdv_sum(p + 52, 512))
                return 0;
            map = p + 52;
            mapsn = sn;
        }
    }
    if (!map || !first || map[2 * mapsn] != 248 || map[2 * mapsn + 1] != 0)
        return 0;
    memcpy(r->fs->label, first + 14, 10);
    strcpy(r->fs->format, "MDV");
    for (i = 0; i < 255; i++) {
        unsigned f = map[i * 2];
        const unsigned char *p = sectors[i];
        if (f == 253 || f == 255)
            continue;
        if (!p)
            return 0;
        if (f == 248) {
            if (p + 52 != map || map[2 * i + 1] != 0)
                return 0;
            continue;
        }
        if (f >= 248 || p[40] != f || p[41] != map[2 * i + 1])
            return 0;
        if (f == 0 && map[2 * i + 1] == 0)
            dir = (unsigned char *)p + 52;
    }
    if (!dir)
        return 0;
    len = u32(dir);
    if (len < 64 || len % 64 || len > 248u * 64)
        return 0;
    dir = mdv_file(sectors, map, 0, len);
    if (!dir)
        return 0;
    for (id = 1; id < len / 64; id++) {
        const unsigned char *h = dir + id * 64;
        unsigned char *raw;
        uint32_t n = u32(h);
        if (!n)
            continue;
        if (h[5] == 255)
            goto done;
        raw = mdv_file(sectors, map, id, n);
        if (!raw)
            goto done;
        /* The per-file header carries authoritative executable metadata. */
        if (u32(raw) != n || u16(raw + 14) != u16(h + 14) || u16(h + 14) > 36 ||
            memcmp(raw + 16, h + 16, u16(h + 14))) {
            free(raw);
            goto done;
        }
        ok = add(r, raw, raw, "");
        free(raw);
        if (!ok)
            goto done;
        ok = 0;
    }
    /* Do not silently omit allocated files outside/deleted from the directory. */
    for (i = 0; i < 255; i++)
        if (map[2 * i] > 0 && map[2 * i] < 248) {
            id = map[2 * i];
            if (id >= len / 64 || !u32(dir + id * 64))
                goto done;
        }
    ok = 1;
done:
    free(dir);
    return ok;
}
/**
 * imagefs_load
 *
 * Load a bounded image into memory, identify its format and decode all files. Return an owned
 * ImageFS or NULL after freeing partial results and reporting failure.
 */
ImageFS *imagefs_load(const char *path) {
    FILE *f = fopen(path, "rb");
    long n;
    Reader r;
    int ok = 0;
    memset(&r, 0, sizeof(r));
    if (!f)
        return NULL;
    if (fseek(f, 0, SEEK_END) || (n = ftell(f)) < 512 || (unsigned long)n > LIMIT ||
        fseek(f, 0, SEEK_SET))
        goto done;
    r.size = (size_t)n;
    r.disk = malloc(r.size);
    r.fs = calloc(1, sizeof(*r.fs));
    if (!r.disk || !r.fs)
        goto done;
    if (fread(r.disk, 1, r.size, f) != r.size)
        goto done;
    memcpy(r.fs->format, r.disk, 4);
    if (!memcmp(r.disk, "QLWA", 4)) {
        memcpy(r.fs->label, r.disk + 6, 10);
        ok = qlwa(&r);
    } else if (!memcmp(r.disk, "QL5A", 4) || !memcmp(r.disk, "QL5B", 4)) {
        memcpy(r.fs->label, r.disk + 4, 10);
        ok = floppy(&r);
    } else if (r.size == 255u * MDV_RECORD)
        ok = microdrive(&r);
done:
    fclose(f);
    free(r.disk);
    free(r.logical);
    free(r.used);
    if (!ok) {
        imagefs_free(r.fs);
        fprintf(stderr, "Unsupported or malformed QL image: %s\n", path);
        return NULL;
    }
    fprintf(stderr, "Mounted %s image read-only: %s (%lu files)\n", r.fs->format, path,
            (unsigned long)r.fs->count);
    return r.fs;
}
