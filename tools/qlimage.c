/* List or extract QL disk images, retaining QDOS headers for writable mounts. */
#include "imagefs.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#ifdef _WIN32
#include <direct.h>
#define mk(p) _mkdir(p)
#else
#define mk(p) mkdir(p, 0700)
#endif
/**
 * safe
 *
 * Validate an image filename for flat host extraction, rejecting path traversal, forbidden
 * characters and reserved host device names.
 */
static int safe(const char *s) {
    char stem[37];
    size_t i;
    if (!*s || *s == '.' || s[strlen(s) - 1] == '.' || s[strlen(s) - 1] == ' ')
        return 0;
    for (i = 0; s[i]; i++) {
        unsigned c = (unsigned char)s[i];
        if (c < 32 || c > 126 || strchr("/\\:*?\"<>|", c))
            return 0;
        stem[i] = (char)(c >= 'A' && c <= 'Z' ? c + 32 : c);
    }
    stem[i] = 0;
    for (i = 0; stem[i] && stem[i] != '.'; i++) {
    }
    stem[i] = 0;
    if (!strcmp(stem, "con") || !strcmp(stem, "prn") || !strcmp(stem, "nul") ||
        !strcmp(stem, "aux"))
        return 0;
    if (strlen(stem) == 4 && (!strncmp(stem, "com", 3) || !strncmp(stem, "lpt", 3)) &&
        stem[3] >= '1' && stem[3] <= '9')
        return 0;
    return 1;
}
/**
 * be32
 *
 * Decode a big-endian QDOS header value without relying on host endianness.
 */
static unsigned long be32(const unsigned char *p) {
    return (unsigned long)p[0] * 16777216 + (unsigned long)p[1] * 65536 + (unsigned)p[2] * 256 +
           p[3];
}
/**
 * writefile
 *
 * Write one complete binary payload/header and check both data writes and close; return false on
 * failure.
 */
static int writefile(const char *p, const void *data, size_t n) {
    FILE *f = fopen(p, "wb");
    int ok;
    if (!f)
        return 0;
    ok = fwrite(data, 1, n, f) == n;
    if (fclose(f))
        ok = 0;
    return ok;
}
/**
 * main
 *
 * List a validated image or extract it into a new destination with QDOS sidecar headers. Refuse
 * an existing destination and report extraction failures.
 */
int main(int argc, char **argv) {
    ImageFS *fs;
    size_t i, j;
    char path[4096], hex[73];
    int extract = argc == 4 && !strcmp(argv[1], "--extract");
    if (!extract && (argc != 3 || strcmp(argv[1], "--list"))) {
        fprintf(
            stderr,
            "Usage: qlimage --list IMAGE\n       qlimage --extract IMAGE NEW_DIRECTORY\nExtracts flat QDOS names and .qlbox-meta headers; destination must not exist.\n");
        return 2;
    }
    fs = imagefs_load(argv[2]);
    if (!fs)
        return 1;
    if (extract) {
        if (strlen(argv[3]) > 3900) {
            fprintf(stderr, "Destination path too long\n");
            goto bad;
        }
        for (i = 0; i < fs->count; i++)
            if (!safe(fs->files[i].name)) {
                fprintf(stderr, "Cannot extract host-unsafe name: %s\n", fs->files[i].name);
                goto bad;
            }
        if (mk(argv[3])) {
            perror("Create new destination");
            goto bad;
        }
        snprintf(path, sizeof(path), "%s/.qlbox-meta", argv[3]);
        if (mk(path)) {
            perror(path);
            goto bad;
        }
    }
    for (i = 0; i < fs->count; i++) {
        ImageFile *f = fs->files + i;
        if (!extract) {
            printf("%-36s %9lu bytes  type %3u  dataspace %lu\n", f->name, (unsigned long)f->size,
                   f->header[5], be32(f->header + 6));
            continue;
        }
        if (f->header[5] == 255)
            continue; /* QDOS directory prefixes are flattened. */
        snprintf(path, sizeof(path), "%s/%s", argv[3], f->name);
        if (!writefile(path, f->data, f->size)) {
            perror(path);
            goto bad;
        }
        for (j = 0; f->name[j]; j++) {
            unsigned c = (unsigned char)f->name[j];
            if (c >= 'A' && c <= 'Z')
                c += 32;
            sprintf(hex + 2 * j, "%02x", c);
        }
        hex[2 * j] = 0;
        snprintf(path, sizeof(path), "%s/.qlbox-meta/%s.hdr", argv[3], hex);
        if (!writefile(path, f->header, 64)) {
            perror(path);
            goto bad;
        }
    }
    if (extract)
        printf("Extracted to %s; mount this directory for writable files.\n", argv[3]);
    imagefs_free(fs);
    return 0;
bad:
    if (extract)
        fprintf(stderr, "Extraction failed; destination may contain partial output.\n");
    imagefs_free(fs);
    return 1;
}
