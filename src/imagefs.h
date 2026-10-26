#ifndef QL_IMAGEFS_H
#define QL_IMAGEFS_H
#include <stddef.h>
#include <stdint.h>
typedef struct {
    char name[37];
    unsigned char header[64], *data;
    uint32_t size;
} ImageFile;
typedef struct {
    ImageFile *files;
    size_t count;
    char label[11], format[5];
} ImageFS;
/* Fully validate/read before publishing a mount; never opens the image writable. */
ImageFS *imagefs_load(const char *path);
void imagefs_free(ImageFS *fs);
#endif
