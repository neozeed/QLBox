#ifndef QLBOX_MODEM_H
#define QLBOX_MODEM_H
/* One outgoing Hayes modem, exposed through a QDOS SER1/SER2 stream channel.
 * All functions except the private DNS worker run on the emulator thread. */
int modem_init(unsigned port, int telnet);
void modem_shutdown(void);
void modem_poll(void);
int modem_command(unsigned command, unsigned request);
/* Byte interface is also used by the integration-test harness. */
int modem_put(unsigned byte);
int modem_get(void);
unsigned modem_available(void);
#endif
