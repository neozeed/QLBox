#ifndef QL_HOSTFS_H
#define QL_HOSTFS_H
#include <stdint.h>
int hostfs_init(const char *root);
int hostfs_mount(unsigned drive, const char *root);
void hostfs_shutdown(void);
void hostfs_command(unsigned command, uint32_t request);
#endif
