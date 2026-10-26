# Keyboard, mounts, configuration (previously interrupted R10 work)

F1-F5 remain native QL function keys. F6-F10 are aliases for Shift+F1-F5.
Home/End map to Shift+Left/Right. Backspace/Delete retain Ctrl+Left/Right.
Shared key releases no longer release another host key holding the same QL key.
Ctrl+F10 resets speed; Ctrl+F11/F12 slow/speed up; plain F12 quits.

Sarien needed an application fix as well: its byte-sized keyboard state was
truncating AGI function-key codes. samples/sarienQL-fixed includes the proven
R4 sound fix plus 16-bit F1-F10 codes. From Sarien beeper R4, update
qlkeyboard.c, qlvid.c, include/keyboard.h and rebuild Sarien. F6-F10 work as
Shift+F1-F5 on a physical QL too. Native keyboard mapping tests pass; the rebuilt
QDOS Sarien has not been compiled or played here. Your existing binary still
runs, but cannot gain this application-level fix from emulator changes alone.

--mount DIR remains WIN1_/HOST1_. Add --mount2 DIR through --mount8 DIR for
WIN2_/HOST2_ through WIN8_/HOST8_. ROM1_ remains the embedded read-only utilities.
Copy files between drives using COPY; cross-drive RENAME is rejected.
Mounts are selected at startup, not changed while guest channels are open.

The default config is ./qlbox.conf; --config FILE selects another;
--no-config disables it. See qlbox.conf.example. Supported keys: ram, speed,
boot, mute, rom, mount/mount1, mount2..mount8. Blank/comment lines are allowed;
unknown entries fail with a filename and line number. CLI overrides config.
Paths are relative to the current working directory, not the config's location.
Clipboard paste, reset, automatic TK2 loading and saved window geometry are
not implemented in this release.
