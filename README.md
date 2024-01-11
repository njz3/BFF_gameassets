# Game assets for BackForceFeeder

## vJoy detected as a wheel

http://vjoystick.sourceforge.net/site/index.php/forum/5-Discussion/1063-how-richard-burns-rally-detects-a-wheel

Modern systems (XP and newer) detects the device capabilities (e.g. Number of buttons, is it a wheel or a joystick) by reading the descriptor the device sends by the USB sub-system.
In the old days (Windows 98), the driver installer had to place these data in the registry when installing.
For some reason, Richard Burns (a.k.a. RBR) goes to this obsolete registry entry to get the device' information.
It seems that RBR relies on this registry value (OEMData) to detect a "race car controller".
According to file mmddk.h [https://sourceforge.net/p/timidity/git/ci/master/tree/windrv/mmddk.h#l230] 
the value to be put in the registry is JOY_HWS_ISCARCTRL, which is 0x40.

So, you should probably change the following Registry entries:
HKEY_CURRENT_USER\System\CurrentControlSet\Control\MediaProperties\PrivateProperties\Joystick\OEM\VID_1234&PID_BEAD
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\MediaProperties\PrivateProperties\Joystick\OEM\VID_1234&PID_BEAD
to
43 00 88 01 fe 00 00 00

The change will take effect after you disable/enable vJoy

=> Change the first nible of previous register keys to 0x4
