#ifndef QL_DEBUGGER_H
#define QL_DEBUGGER_H
int debugger_init(unsigned port, int wait, const char *log_path);
void debugger_close(void);
int debugger_execute(int cycles);
void debugger_output(unsigned value);
void debugger_control(unsigned value);
int debugger_enabled(void);
#endif
