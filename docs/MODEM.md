# Outgoing TCP modem (R22)

QLBox exposes a Hayes-style modem as a normal QDOS serial stream. A guest
terminal sends AT commands and sees modem result text. After dialing,
serial bytes travel over an outgoing TCP connection. It is a host-backed
QDOS driver, not an electrical simulation of the QL serial hardware.

## Start with QLTerm 3.00b2

The supplied QLTerm archive contains QDOS executable metadata. To install it
without losing that metadata, copy the archive into a writable mount under
the host filename `QLT300B2_ZIP`, then run from the QLBox package directory:

```bat
mkdir qlterm
copy QLT300b2.zip qlterm\QLT300B2_ZIP
bin\win64\qlrun.exe --ram 640 --mount qlterm --run ROM1_UNZIP --args "-o -j WIN1_QLT300B2_ZIP QLTERM -d WIN1_"
bin\win64\qlbox.exe --ram 640 --mount qlterm --modem ser2
```

In BASIC, enter `EXEC_W WIN1_QLTERM`. If you already extracted QLTERM using a
host unzip tool, its verified 3.00b2 executable dataspace is 10240 bytes:
`python tools/qlfile.py exec qlterm/QLTERM --data-space 10240` restores that
metadata. This size is specific to the supplied build, not every QLTerm version.

QLTerm's supplied default interface is **Telnet**, which expects a native TCP
QDOS device. For this modem, select its **serial** interface instead:

1. Press F3, then I for Interface.
2. Keep **Echo Off** and press Enter. The modem echoes command-mode characters.
3. Select **SER2I** with the arrow keys and press Enter. From the supplied
   Telnet default this is three Left presses.
4. Press Enter to retain the baud rate. This virtual transport is not baud-paced.

Now type `AT` and press Enter: `OK` should appear. Dial with either:

```text
ATDT vert.synchro.net
ATDT test.whatever:2323
```

The first uses TCP port 23. The second illustrates a custom port; replace
its example hostname with your endpoint. These are syntax examples, not a
claim that those public services were contacted or are currently available.
QLTerm's F3/C Connect command also uses its configured serial dial prefix
(`ATD` by default), so entering the hostname there follows the same modem path.

Use ordinary serial mode even though QLBox's underlying transport is Telnet.
Having both application and modem interpret Telnet IAC would double-handle
negotiation. The QLTerm executable and supplied source were used for testing
and interface research; they are not included in this emulator distribution.

## Configuration

| Option | Meaning |
|---|---|
| `--modem ser2` | Default: claim SER2 and standard suffixes, including SER2I/SER2H |
| `--modem ser1` | Claim SER1 instead, leaving SER2 to the stock ROM |
| `--modem off` | Do not install the host modem bridge |
| `--modem-mode telnet` | Default: handle Telnet protocol beneath the serial stream |
| `--modem-mode raw` | Preserve the network payload bytes without Telnet processing |

Config keys are `modem=ser2` and `modem_mode=telnet`; CLI options override them.
The QIMSI mouse uses its own memory-mapped interface, so it occupies neither
serial port. Only one modem channel/connection is available at a time. Opening
it twice reports QDOS in-use; closing it hangs up. Neither startup nor opening
the serial channel initiates a network connection: the guest must dial.

The untouched ROM serial device remains on the other port, but R21 does not
add physical host COM/tty forwarding or make the stock serial hardware usable.
Serial suffixes are recognized for compatibility; hardware parity, handshake
lines and baud timing are not simulated. Guest programs using QDOS stream I/O
are supported; programs bypassing QDOS for direct UART/IPC I/O are outside scope.

## Command subset

Commands are case-insensitive; hostname spelling is preserved. End a command
with CR or LF. CRLF is accepted once. Backspace/DEL edits the command buffer.
Ordinary E/Q/V settings can be combined, for example `ATE0V1Q0`.

| Command | Result/action |
|---|---|
| `AT` | `OK` |
| `ATDhost`, `ATDThost`, `ATDPhost` | Dial hostname or IPv4, optionally `:port`; T/P are equivalent |
| `ATDT[::1]:2323` | Bracketed IPv6 literal with optional port |
| `ATE0`, `ATE1` | Command echo off/on |
| `ATV0`, `ATV1` | Numeric/text result codes |
| `ATQ0`, `ATQ1` | Result codes enabled/quiet |
| `ATI` or `ATI0` | Identify as QLBox TCP modem |
| `ATZ` / `AT&F` | Hang up and restore E1, Q0, V1 and S12=50 |
| `ATH` / `ATH0` | Hang up |
| `ATO` / `ATO0` | Return from online command mode to the existing connection |
| `ATS12?` / `ATS12=n` | Read/set escape guard in 20 ms units, 0..255 |

Unsupported commands or invalid destinations return `ERROR`. This is not
complete Hayes compatibility: no stored profiles, phonebook, incoming call
listener, ATA, auto-answer, dial tones or modem control lines are implemented.
Numeric results are OK=0, CONNECT=1, NO CARRIER=3, ERROR=4 and BUSY=7.

## Command mode, data mode and hangup

A successful connection returns `CONNECT` and switches to data mode. There,
bytes such as `ATH` are remote text, not modem commands. To regain command
mode, leave transmitted data idle for one second, send exactly `+++` without
Enter, then leave another second of silence. The modem returns `OK` and keeps
the connection. Use `ATH` to disconnect or `ATO` to resume it. Unguarded plus
characters remain data. Guard intervals use host time, independent of the CPU
speed setting; retain 1x for guest scripts that generate timed escape sequences.

Any input during an outstanding dial cancels it (the LF half of the original
CRLF terminator is ignored). Refused connections, lookup failure and a 30-second
dial timeout return `NO CARRIER`. Closing a live connection from the remote end
also returns `NO CARRIER` after buffered bytes are delivered. In online command
mode, socket reads pause until ATO, so remote disconnect detection can be delayed.

DNS runs on a separate worker. Cancelling a slow DNS lookup does not freeze the
emulator; its result is discarded when ready. A second dial reports BUSY until
that cancelled lookup has been reaped. Host resolver behavior can outlast the
30-second user-visible dial timeout, but cannot create a late cancelled connection.

## Telnet and binary data

Telnet mode handles fragmented IAC commands and subnegotiation, doubles outgoing
IAC data, accepts incoming escaped IAC and requests BINARY in both directions
on every connection. It waits for agreement before enabling binary; refusal
leaves NVT text mode. It also negotiates remote echo and
suppress-go-ahead. It advertises ANSI terminal type and a fixed 80x24 size when
requested; the guest terminal should use corresponding settings. Unsupported
options are refused. Outside negotiated binary mode, CR-NUL is translated to a
single guest CR, and outgoing isolated CR receives an NVT NUL terminator;
CR-LF is retained. High-bit bytes are not artificially stripped.

Raw mode does no Telnet translation. The real-QDOS test exchanges all 256 byte
values over raw TCP, including a fragmented blocking block read through real
QDOS scheduler retries. For file transfers, use a raw-capable server or a
Telnet server accepting BINARY in both directions. Telnet support is a practical
subset, not an SSH/TLS implementation.

Two 64 KiB queues provide bounded buffering. Socket reads pause when the guest
falls behind, and guest writes report not-complete when transmit buffering is
full. This supplies backpressure at the QDOS/TCP boundary; physical RTS/CTS
pins are not emulated. XON (0x11) and XOFF (0x13) remain payload bytes, so binary
files are not damaged by an implicitly enabled software handshake mode.
TCP connect/read/write never block the emulator thread. Networking and
escape timers use monotonic host time, not accelerated guest frame counts.

## Try a local connection first

Run `python tools/modem-test-server.py` on the emulator host, then dial
`ATDT 127.0.0.1:2323` inside QLTerm. It binds only to loopback, displays an ANSI
greeting and echoes entered lines. Ctrl+C stops the server. This is a small
manual smoke tool, not a BBS or a Telnet protocol test server.

## Validation and implementation

`make modem-test` runs loopback-only tests: command settings/errors, hostname/IP
dialing, refused/cancelled dials, queue-sized binary streams, Telnet fragmentation,
IAC escaping, terminal type, NVT/binary CR handling, guarded escape/resume/hangup,
QDOS bridge bounds/partial registers and an actual guest serial executable.

The original QLTerm 3.00b2 was also driven through its real keyboard menus into
SER2I, dialed localhost, displayed an ANSI BBS banner and sent keyboard input
back to the server. `tests/qlterm_modem.c` preserves that optional UI smoke
harness; it requires the user-supplied executable and a local test server.
No public BBS was contacted. Linux execution and Win32/Win64 cross-builds were
checked; Windows/macOS runtime validation remains for those hosts.

The JS ROM is unchanged. `src/modem.c` is dispatched before terminal/file
operations in the existing host-device MMIO bridge. A negative tagged handle
keeps ordinary QDOS stream-channel identity and scheduling. No application
name detection, guest-code patch or PC-specific modem interception is used.

Protocol references:

- [RFC 854: Telnet](https://www.rfc-editor.org/rfc/rfc854)
- [RFC 856: Binary transmission](https://www.rfc-editor.org/rfc/rfc856)
- [RFC 1091: Terminal type](https://www.rfc-editor.org/rfc/rfc1091)
- [RFC 1073: Window size](https://www.rfc-editor.org/rfc/rfc1073)

QLTerm interface behavior was checked against the supplied source, particularly
MAIN.ASM and serio.asm; see [PROVENANCE.md](PROVENANCE.md).

## R22 transfer correction and QLTerm settings

R21 treated each scheduler retry as a new block request. QDOS actually keeps
D2 at the original length, carries the cumulative transferred count in D1,
and advances A1. R22 subtracts that count and accumulates new progress for
IO.FSTRG, IO.FLINE and IO.SSTRG. This prevents waiting for excess bytes,
reading beyond a requested buffer, and repeated/incorrect string-write counts.
The ROM's existing scheduler and driver bridge are unchanged.

For the supplied QLTerm 3.00b2, select SER2I, then **F3, B, 32, Enter** before
downloading to WIN1. B is an existing buffer-size command even though the main
menu does not list it. Its startup comparison in MAIN.ASM clears BUFLEN for
non-RAM destinations (the BEQ branch contradicts its adjacent comment).
With a zero buffer, FILEXFER.ASM writes each block immediately and calls
DL_SAVE again at EOT, duplicating the last block. Restoring a 32 KiB buffer
through the menu avoids this separate guest-program problem. QLBox does not
patch guest code to hide it.

Optional integration test with your own QLTerm archive:

```
make qlbox-qlterm-modem-test
python3 tests/qlterm_transfer.py /path/to/QLT300b2.zip
```

The test changes only QLTerm's configurable download directory to WIN1_,
selects SER2I and the download buffer via real keyboard menus, and uses a
loopback peer that accepts Telnet BINARY and fragments CRC-protected blocks.
It compares the saved file with the original 2048-byte binary payload.
The QLTerm binary is not distributed with QLBox. Its protocol menu includes
XMODEM, XMODEM-1K, YMODEM and YMODEM-G, not ZMODEM. ZMODEM requires a separate
guest implementation and remains unverified; passing a byte-stream test alone
is not evidence of a completed ZMODEM session.
