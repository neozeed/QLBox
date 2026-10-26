# Function reference

Every function defined in QLBox's `src/*.c` and `tools/qlimage.c` is described
in its source and indexed here. Generated utility data and third-party source
are separate; see SOURCE_GUIDE.md and PROVENANCE.md.

## src/beeper.c

- **`ql_beeper_start`** — Decode the 16-nibble IPC sound request and restart the square-wave generator. Zero duration means continuous sound; remaining time uses the fixed-point sample units described above.
- **`ql_beeper_stop`** — Silence the beeper immediately, discard its remaining duration and record a stop for diagnostics.
- **`ql_beeper_render`** — Fill count mono samples, advancing phase and duration even when the host audio output is muted. Inactive samples are zero; this initializes the buffer before QSound is mixed into it.

## src/mouse.c

- **`part`** — Clamp one signed movement component to a legal packet-sized step.
- **`packet`** — Append one four-byte mouse report. On overflow retain the report currently being read and replace older queued reports with the newest state.
- **`ql_mouse_note_read`** — Record a real guest interface read. Two distinct recent frames are needed to distinguish active polling from a one-frame hardware probe.
- **`ql_mouse_active`** — Return whether polling has armed capture and the last read is less than 50 emulated frames old. Unsigned subtraction permits frame-counter wrap.
- **`ql_mouse_init`** — Clear packet and polling state, then enable the emulated interface by default.
- **`ql_mouse_event`** — Convert host relative motion, wheel movement and three button bits into bounded PS/2 reports. Split large movements instead of silently truncating them.
- **`ql_mouse_release`** — Discard stale queued motion, preserve any partially consumed packet and enqueue a button-release report.
- **`ql_mouse_read`** — Read CODE, UNLOCK or STATUS. A consuming UNLOCK read advances the packet; consume=0 lets inspection observe the interface without advancing it.

## src/qsound.c

- **`chip_reset`** — Reset AY registers, tone/noise counters and envelope state without clearing the surrounding PIA configuration or host mixer state.
- **`ql_qsound_init`** — Initialize the complete board model and enable data-register access so direct-register players can run without expansion firmware.
- **`reg_write`** — Mask a write to the selected AY register. Writing envelope shape restarts the envelope, including its attack, hold and alternate behavior.
- **`ql_qsound_write`** — Dispatch one PIA register write, interpreting data-direction selection and AY control strobes. Latch/write actions occur only on a control-state transition.
- **`ql_qsound_read`** — Return the selected PIA register or AY read-bus value. Unattached AY input ports read high; disabled hardware reads as 0xff.
- **`tick`** — Advance one AY clock/8 tick: update three square waves, the noise LFSR and the envelope counters. Zero programmed periods are treated as one.
- **`output`** — Compute the instantaneous sum of enabled tone/noise channels using fixed volume or the current envelope level.
- **`ql_qsound_mix`** — Advance the 750 kHz chip clock through eight sub-samples per PCM sample, remove DC approximately and saturating-add the result to the existing beeper buffer.

## src/hostfs.c

- **`select_drive`** — Select the backing directory used by the following operation. Handles retain their drive number so later I/O can restore this context.
- **`get16`** — Read a big-endian 16-bit guest value without host alignment or byte-order assumptions.
- **`get32`** — Read a big-endian 32-bit guest value without casting guest bytes to a host integer.
- **`put16`** — Store the low 16 bits of a value in big-endian guest byte order.
- **`put32`** — Store a 32-bit value in big-endian guest byte order.
- **`ram`** — Return whether the entire guest byte range lies inside configured writable RAM. Subtraction avoids an overflowing end address.
- **`readable`** — Accept a byte range wholly inside the main ROM or configured RAM; reject I/O and unmapped ranges.
- **`lower`** — Fold ASCII uppercase letters for guest filename matching, independently of the host locale.
- **`equal`** — Compare complete guest names using ASCII case folding. Dots and underscores remain distinct.
- **`prefix`** — Test a case-insensitive ASCII prefix, used for device names and directory filtering.
- **`valid`** — Validate the flat host-drive filename contract, including length, forbidden path characters and reserved device stems. empty controls whether an empty directory name is allowed.
- **`path`** — Join the selected root and an already validated filename into PATHCAP bytes. Return false if the result would be truncated.
- **`regular`** — Accept only supported regular host files with a representable QDOS length; reject symlinks/reparse points and directories.
- **`addname`** — Append a validated regular filename to a temporary directory snapshot; record allocation/entry-limit failure in the snapshot.
- **`namecmp`** — Provide case-insensitive ASCII ordering for qsort; this also puts conflicting case variants next to one another.
- **`names`** — Enumerate the selected host directory, sort eligible files and reject ambiguous case-insensitive duplicates. The caller frees names even on error.
- **`resolve`** — Resolve a guest name to its actual host spelling. Return a QDOS status separately from exists so a missing file can still be created.
- **`meta_path`** — Build the sidecar header path by hex-encoding the case-folded filename; metadata filenames cannot introduce path separators.
- **`meta_directory`** — Validate the metadata directory, creating it only when requested. Return a QDOS error if it is missing or unsuitable.
- **`meta_regular`** — Reject an existing metadata path that is not a safe regular file; a missing path remains acceptable for creation.
- **`header_load`** — Construct the 64-byte QDOS header. Explicit sidecar metadata takes precedence over an XTcc executable trailer; payload size and filename come from the current host file.
- **`header_save`** — Persist the handle header to its metadata sidecar. Return zero on success or a QDOS error; payload bytes are stored separately.
- **`size_file`** — Obtain the current payload length for a stream or buffered directory and reject values outside the supported QDOS range.
- **`guest_name`** — Decode a counted guest name, select its mount slot and validate the remaining filename. Recognize ROM1 separately and allow the boot-only BOOT alias.
- **`busy`** — Check open handles on the selected drive for conflicting access. Multiple read-only opens may coexist.
- **`builtin_header`** — Synthesize a QDOS header from an embedded utility entry, including its executable type and dataspace.
- **`builtin_open`** — Open an embedded utility or construct a ROM1 directory stream. Allocate a normal host handle but reject creation and writes.
- **`image_open`** — Open a file or directory view from an already decoded image, using the same handle interface as host files while preserving read-only semantics.
- **`open_file`** — Validate and resolve an open request, dispatch ROM1/image mounts, or open/create a host payload and its header. Return the allocated handle ID through id.
- **`close_file`** — Flush writable payload/header state, close the host stream and free buffered directory data. Invalidate the handle even if finalization reports an error.
- **`delete_file`** — Delete a validated, non-busy host file and its sidecar. Embedded utilities and mounted images reject deletion.
- **`transfer`** — Perform byte, line or block I/O for a handle. Update the guest pointer, byte count and file position, returning QDOS EOF or buffer-full status where appropriate.
- **`io_file`** — Dispatch a QDOS I/O opcode using the six-long request block. Implements transfers, positioning, headers and file-management operations; unsupported operations return NI.
- **`hostfs_init`** — Reset the handle/mount state and install the initial slot-1 mount. Return false if it cannot be mounted.
- **`hostfs_shutdown`** — Close all live handles and release decoded image allocations for every mount slot.
- **`hostfs_mount`** — Install a host directory or supported read-only image in one of eight slots. Reject replacing a drive with open handles.
- **`hostfs_command`** — Read the ROM bridge request from guest RAM, dispatch open/I/O/close/delete and write the updated register block back. Optional trace output reports errors and early operations.

## src/imagefs.c

- **`u16`** — Read a big-endian 16-bit guest value without host alignment or byte-order assumptions.
- **`u32`** — Read a big-endian 32-bit guest value without casting guest bytes to a host integer.
- **`p32`** — Store a 32-bit value in big-endian guest byte order.
- **`lower`** — Fold ASCII uppercase letters for guest filename matching, independently of the host locale.
- **`same`** — Compare complete image filenames using ASCII case folding.
- **`imagefs_free`** — Release every decoded payload and the filesystem container; NULL is accepted for error-path cleanup.
- **`add`** — Validate one image header and add an owned payload copy to the filesystem. Normalize length to exclude the on-image 64-byte header and reject duplicate names.
- **`chain`** — Copy a QLWA allocation chain into a newly allocated buffer. Track used units to reject loops, shared allocations and incorrect termination; caller owns the result.
- **`qlwa_dir`** — Walk a QLWA directory recursively with a depth bound, reconstructing full guest names and decoding each allocation chain. Return false on malformed entries.
- **`qlwa`** — Validate QLWA geometry and allocation-map bounds, reserve map units, then load the root directory.
- **`flp_file`** — Reassemble a QL5A/QL5B file by file ID and sequence number. Reject missing, duplicate or shared allocation units; caller owns the returned buffer.
- **`floppy`** — Validate floppy geometry, convert QL5A skewed sectors to logical order, check the allocation map and decode the flat directory.
- **`mdv_sum`** — Validate a microdrive block checksum: a 16-bit sum seeded with 0x0f0f, stored little-endian after the checked bytes.
- **`mdv_file`** — Reassemble a microdrive file from map-selected sectors, checking file IDs, sequence numbers and header/data checksums.
- **`microdrive`** — Decode a QLAY-format cartridge by sector number rather than physical record order. Validate the map, directory and every allocated file before accepting it.
- **`imagefs_load`** — Load a bounded image into memory, identify its format and decode all files. Return an owned ImageFS or NULL after freeing partial results and reporting failure.

## src/ql.c

- **`irq_update`** — Drive Musashi interrupt level 2 when any emulated pending source is set; otherwise deassert the CPU interrupt input.
- **`irq_ack`** — Count a CPU interrupt acknowledgement and request the standard autovector. Guest I/O acknowledges the pending hardware sources separately.
- **`held_keys`** — Report whether a non-modifier key remains held for the IPC repeat/status protocol.
- **`reply`** — Latch a serial IPC response and the number of bits remaining to be shifted out.
- **`ipc_command`** — Interpret a completed IPC command nibble or its pending parameter. Implements keyboard/status/test exchanges and functional beeper control rather than executing an 8049 ROM.
- **`ipc_write`** — Advance the serial IPC handshake: shift a reply bit when one is pending, otherwise collect four incoming bits into a command nibble.
- **`ql_ram_wait`** — Calculate clocks until a permitted onboard-RAM transfer slot at the supplied horizontal clock phase. This is the experimental contention model, not a raster renderer.
- **`timing_begin`** — Mark the start of an execution group and reset its bus cursor and additional-cycle accumulator.
- **`timing_end`** — Finish timing an execution group, padding it if scheduled bus transfers outlast the core-reported cycles, then advance the absolute clock.
- **`ql_set_timing`** — Select fast, bus-only or contended timing, reset all accounting and install or remove the Musashi cycle callbacks.
- **`timing_access`** — Charge one CPU memory transfer for external byte-bus width and, in ql mode, onboard-RAM contention. Inspection outside an active execution group is not charged.
- **`raw_read8`** — Decode one 20-bit bus address without adding timing. Reads of IPC and mouse registers may consume device state; unmapped addresses return 0xff.
- **`m68k_read_memory_8`** — Musashi CPU callback: charge a 8-bit transfer and read guest bytes in big-endian order.
- **`m68k_read_memory_16`** — Musashi CPU callback: charge a 16-bit transfer and read guest bytes in big-endian order.
- **`m68k_read_memory_32`** — Musashi CPU callback: charge a 32-bit transfer and read guest bytes in big-endian order.
- **`m68k_read_disassembler_8`** — Musashi inspection callback: read 8 bits without CPU timing charges or consuming mouse reports. Other mapped reads retain raw device-read semantics.
- **`m68k_read_disassembler_16`** — Musashi inspection callback: read 16 bits without CPU timing charges or consuming mouse reports. Other mapped reads retain raw device-read semantics.
- **`m68k_read_disassembler_32`** — Musashi inspection callback: read 32 bits without CPU timing charges or consuming mouse reports. Other mapped reads retain raw device-read semantics.
- **`raw_write8`** — Decode one byte write to RAM, hardware or the ROM/host bridge. ROM writes are ignored; bridge command writes dispatch the prepared request immediately.
- **`m68k_write_memory_8`** — Musashi CPU callback: charge a 8-bit transfer and dispatch its bytes in big-endian order.
- **`m68k_write_memory_16`** — Musashi CPU callback: charge a 16-bit transfer and dispatch its bytes in big-endian order.
- **`m68k_write_memory_32`** — Musashi CPU callback: charge a 32-bit transfer and dispatch its bytes in big-endian order.
- **`hook`** — Observe known addresses in the bundled ROM for boot readiness and trace messages. It does not replace instruction execution or patch guest registers.
- **`ql_init`** — Reset the machine, validate RAM and the supplied 64 KiB ROM, find its keyboard table and reset the Musashi CPU. Return false on unsupported configuration or ROM input.
- **`ql_load_qsound_rom`** — Validate an 8/16 KiB expansion image and copy it to the read-only mapping at 0xc0000 before boot. JS discovers the ROM through its normal expansion scan.
- **`ql_frame`** — Run one nominal 20 ms frame as fifty CPU/audio slices, assert the frame interrupt and mix sound. Optional timing debt carries instruction overshoot between slices.
- **`ql_key`** — Update a physical key and modifier state, queuing only a new key-down transition when the IPC queue has room.
- **`ql_release_keys`** — Clear held/repeat/modifier state on focus loss so the guest does not retain stuck keys.
- **`ql_map_char`** — Invert the loaded ROM keyboard tables to find a key/modifier encoding for a character. Return -1 if no mapping exists.
- **`ql_type`** — Queue a character through the real IPC keyboard path; return false if it is unmappable or the key queue is full.
- **`ql_render`** — Decode the selected screen bank into 512x256 opaque ARGB pixels, including mode-8 doubled pixels, flash and display blanking. Reads final frame state, not raster history.
- **`ql_ppm`** — Render and write a binary PPM screenshot. Return true only if writes and close succeed.
- **`ql_dump`** — Write the complete 1 MiB memory backing array for inspection, including regions outside configured RAM. Return true on successful write and close.
- **`ql_status`** — Print machine counters and, when enabled, experimental timing totals for reproducible diagnostics.

## src/sdl_input.c

- **`keycode`** — Map SDL special/physical keys to QL key numbers; return the unmapped sentinel for keys handled elsewhere.
- **`ql_sdl_input`** — Translate SDL keyboard/text/focus events into guest key state. Coordinate text input with physical keys to avoid duplicate characters.
- **`ql_sdl_speed_control`** — Handle CPU-speed hotkeys and report whether the event was consumed.
- **`ql_sdl_mouse_captured`** — Return the frontend capture flag used by the title and event loop.
- **`ql_sdl_mouse_speed`** — Set the host-motion gain used when forming guest mouse reports.
- **`capture_mouse`** — Request SDL relative mouse mode, update the capture flag on success and release guest buttons when leaving capture.
- **`ql_sdl_mouse_update`** — Release capture when guest polling is no longer active; report whether capture eligibility changed so the window title can be refreshed.
- **`ql_sdl_mouse`** — Handle capture/release hotkeys, focus changes and relative mouse events. Capture requires recent guest reads and an explicit click or hotkey.

## src/main.c

- **`speed_title`** — Update the SDL title with CPU speed and current mouse-capture eligibility/state.
- **`config_args`** — Translate configuration settings into command-line arguments placed before explicit options so the latter win. Validate keys, values and mount slots before startup.
- **`interrupt_run`** — Record a host signal in the signal-safe interruption flag; normal loop cleanup handles termination.
- **`default_rom`** — Probe supported working-directory and executable-relative locations for the bundled ROM, writing candidate paths into the caller buffer.
- **`usage`** — Print the command-line interface and exit conventions implemented by this build.
- **`main`** — Parse startup options, initialize the guest and optional SDL/GDB services, then run the presentation or terminal loop. Finalize dumps, status and resources and return the guest/host result.

## src/debugger.c

- **`hex`** — Decode one hexadecimal digit or return -1 for invalid input.
- **`disconnect`** — Close the debug client and clear session-specific stop, packet and breakpoint state while leaving the listening socket available.
- **`sendall`** — Send a complete protocol message, retrying partial writes. Disconnect and return false if the socket cannot accept more data.
- **`packet`** — Frame a GDB response with its checksum and retain it for retransmission on a negative acknowledgement.
- **`number`** — Parse one to eight hexadecimal digits into a 32-bit value and advance the input cursor; reject empty or overlong values.
- **`decode`** — Decode an exactly sized hex byte string, rejecting invalid characters or length.
- **`mapped`** — Check a debugger memory range against readable ROM or writable RAM. Device registers are excluded from this direct-access interface.
- **`resume`** — Validate an optional new PC and resume continuous or single-step execution, skipping the current breakpoint once.
- **`command`** — Dispatch a validated GDB remote-protocol payload: registers, memory, execution control, breakpoints and capability queries. Unsupported packets receive an empty reply.
- **`ready`** — Poll a socket for readable data without waiting, keeping debugger checks within the emulator loop.
- **`poll_socket`** — Accept a local debugger connection and assemble bounded packets, checking checksums and handling acknowledgements and interrupt requests.
- **`debugger_init`** — Initialize the guest log and optional loopback GDB listener, including the target register description. Return false if initialization fails.
- **`debugger_execute`** — Run the requested CPU budget directly when debugging is off; otherwise interleave execution with stop, single-step, breakpoint and socket handling.
- **`debugger_enabled`** — Report whether a GDB listening socket is active.
- **`flush_line`** — Emit a buffered guest diagnostic line to the chosen log or stderr and reset its length.
- **`debugger_output`** — Accept one byte from the guest diagnostic port, ignoring CR/NUL and flushing on newline or a full buffer.
- **`debugger_control`** — Interpret guest control bits to flush diagnostics or request a debugger stop when a listener exists.
- **`debugger_close`** — Flush final diagnostics and close the log, client and listener resources.

## src/terminal.c

- **`get32`** — Read a big-endian 32-bit guest value without casting guest bytes to a host integer.
- **`put32`** — Store a 32-bit value in big-endian guest byte order.
- **`ram`** — Return whether the entire guest byte range lies inside configured writable RAM. Subtraction avoids an overflowing end address.
- **`readable`** — Accept a byte range wholly inside the main ROM or configured RAM; reject I/O and unmapped ranges.
- **`terminal_init`** — Reset stream channels and input queue; on Windows, select binary stdout for redirected output to preserve guest bytes.
- **`feed`** — Append a host input byte with CR/CRLF normalized to one guest newline. The caller reserves queue capacity.
- **`terminal_poll`** — Collect available console/pipe input into the queue. A short wait is allowed when a guest read is pending; EOF is retained for subsequent QDOS requests.
- **`open_terminal`** — Recognize counted CON/SCR names and allocate a tagged stream handle. Return zero for another driver, one for success or a negative allocation error.
- **`io`** — Execute stream I/O against the shared input queue and stdout. Return not-complete for pending reads so QDOS can retry; SCR rejects input and graphics operations are unsupported.
- **`terminal_command`** — Handle a ROM bridge request only when the CLI runner is active and the target is a tagged terminal channel. Return zero to let hostfs try another driver.

## tools/qlimage.c

- **`safe`** — Validate an image filename for flat host extraction, rejecting path traversal, forbidden characters and reserved host device names.
- **`be32`** — Decode a big-endian QDOS header value without relying on host endianness.
- **`writefile`** — Write one complete binary payload/header and check both data writes and close; return false on failure.
- **`main`** — List a validated image or extract it into a new destination with QDOS sidecar headers. Refuse an existing destination and report extraction failures.

