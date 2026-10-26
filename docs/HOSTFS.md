# ROM/host interface

The QLBox ROM extends the UK JS ROM to 64 KiB. Original code offsets remain
stable. The host device code begins at 0xC000 and chains to the original
device driver. Physical microdrive BOOT fallback is skipped.

The ROM saves D0-D3/A0-A1 as six big-endian longs on the supervisor stack.
It writes the request address to 0x18104 (long), then a command to 0x18100
(byte): 1 open, 2 I/O, 3 close, 4 delete. The backend updates the saved
registers synchronously. Guest address ranges are checked before transfer.

Open receives the QDOS counted filename at A0 and access mode in D3.
Successful host open returns a backend handle in D1; the ROM allocates a
128-byte QDOS channel and stores that handle at channel offset 24.
I/O and close use that field. The ROM releases channel storage through QDOS.
The host driver returns unsupported for other device prefixes, allowing
QDOS to continue its ordinary driver chain.

Read-only configuration registers:
* 0x18110: RAM top, big-endian long.
* 0x18114: boot selection, 0xEC TV or 0xE8 monitor.

Reset clears configured RAM without the hardware probe/pattern test.
The boot-mode routine reads the configuration register instead of waiting
for F1/F2. The rest of console initialization stays in the ROM.

Payload files stay native host files. Sidecar names are the lowercase
filename encoded as hex plus .hdr in .qlbox-meta; each holds 64 QDOS header
bytes. File length is derived from the payload. Directory entry length
includes the 64-byte header. Executable type is byte 5 and data-space is the
big-endian long at offset 6.

The backend rejects unsupported path syntax and links in normal use; it is
not a security boundary against another host process racing filesystem changes.


R4 adds a separate host_file_driver entry in SV.DDLST. File channels point to
this entry; terminal channels retain the stream-driver pointer. This allows
C libraries which inspect QDOS driver chains to identify seekable files.
The channel includes drive number 1 at offset 0x1D and a counted filename at
offset 0x32. QDOS remains responsible for channel IDs, ownership and closing.
The normal SDEV open entry still performs host-backed opens; the DDEV fallback
rejects unavailable files and formatting. It chains to the existing MDV entry.

Opening WIN1_ / HOST1_ in old/shared mode returns a read-only directory stream.
Directory headers use QDOS type 255. Creating/overwriting the root remains
rejected. Directory mode 4 still supports flat prefix-filtered listings.
