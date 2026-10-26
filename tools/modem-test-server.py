#!/usr/bin/env python3
"""A loopback-only greeting/echo server for checking a QLBox modem build.

Run it on the same host, then dial ATDT 127.0.0.1:2323 in the guest terminal.
This deliberately sends ordinary text, not Telnet negotiations or a login.
"""
import argparse
import socket


def main():
    """Accept local clients and echo entered lines until the client hangs up."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', type=int, default=2323)
    args = parser.parse_args()
    if not 1 <= args.port <= 65535:
        parser.error('port must be 1..65535')
    with socket.socket() as listener:
        listener.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        listener.bind(('127.0.0.1', args.port))
        listener.listen(1)
        print(f'Local test server: dial ATDT 127.0.0.1:{args.port}', flush=True)
        while True:
            client, address = listener.accept()
            print('Connected:', address, flush=True)
            with client:
                try:
                    client.sendall(b'\x1b[32mQLBox local modem test\x1b[0m\r\n'
                                   b'Type a line; use guarded +++ and ATH to hang up.\r\n> ')
                    line = bytearray()
                    after_cr = False
                    while True:
                        data = client.recv(1024)
                        if not data:
                            break
                        for byte in data:
                            # Telnet mode may append NUL to a lone NVT CR.
                            if after_cr and byte in (0, 10):
                                after_cr = False
                                continue
                            after_cr = byte == 13
                            if byte in (10, 13):
                                client.sendall(b'\r\nReceived: ' + line + b'\r\n> ')
                                line.clear()
                            elif byte in (8, 127):
                                if line:
                                    line.pop()
                                    client.sendall(b'\b \b')
                            elif len(line) < 1024:
                                line.append(byte)
                                client.sendall(bytes([byte]))
                except (ConnectionError, OSError) as error:
                    print('Connection ended:', error, flush=True)
            print('Disconnected', flush=True)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass
