#ifndef QL_TERMINAL_H
#define QL_TERMINAL_H
void terminal_init(void);
void terminal_poll(void);
int terminal_command(unsigned command, unsigned request);
#endif
