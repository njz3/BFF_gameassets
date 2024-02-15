https://www.emuline.org/topic/51-emu-dolphin-50-triforce-branche-arcade-namco-sega-nintendo-gc-wii/?do=findComment&comment=141052

karting game

Z = test mode + coin in test menu (it's an error ?)

X = service + coin in game

Analog left stick : left - right - up - down

A = item

B = cancel button

R = Gas

L = Brake


To configure controls:
- open Controller Settings in Dolphin
- tick Background input at the bottom
- select Standard Controller in the top
- map your inputs (see list above)
- close and change Port 1 to Triforce AM 

CONFIG>>GAMECUBE>> SP1 = Triforce AM Baseboard

CONTROLLER>>Port 1 = Triforce AM Baseboard


GECKO CODES:
it is advisable to have separate portable build for the jpn version
=> create an empty portable.txt file in dolphin directory.

https://www.emuline.org/topic/51-emu-dolphin-50-triforce-branche-arcade-namco-sega-nintendo-gc-wii/?do=findComment&comment=142741

Mario Kart GP :
Slowdown Fix
041b2238 60000000
Link Check Skip
04032410 60000000

Mario Kart GP2 :
Slowdown Fix (US)
04086150 60000000
Link Check Skip (US)
0402eb6c 60000000
 
Mario Kart GP2 (JPN) :
Slowdown Fix (JPN)
04086768 60000000
Link Check Skip (JPN)
0402ebcc 60000000


https://www.emuline.org/topic/51-emu-dolphin-50-triforce-branche-arcade-namco-sega-nintendo-gc-wii/?do=findComment&comment=144577

Mario Kart Arcade GP
Slowdowns Fix (Required)
041b2238 60000000
Link Check Skip (Optional)
04032410 60000000 
Skip boot checks (Optional)
040320fc 60000000
 

Mario Kart Arcade GP 2
Slowdowns Fix (US - Required)
04086150 60000000
Link Check Skip (US - Optional)
0402eb6c 60000000
Skip boot checks (US - Optional)
0402e858 60000000

---

Slowdowns Fix (JPN - Required)
04086768 60000000
Link Check Skip (JPN - Optional)
0402ebcc 60000000
Skip boot checks (JPN - Optional)
0402e8b8 60000000


https://www.emuline.org/topic/51-emu-dolphin-50-triforce-branche-arcade-namco-sega-nintendo-gc-wii/?do=findComment&comment=143670
here are the proper widescreen patches for the mario kart games (aspect ratio needs to be set to forced 16:9)
 

Mario Kart GP Widescreen

C228C800 00000009
C03F0034 9421FFE0
93C10004 93E10008
DBE1000C 7FC802A6
48000009 3FAAAAAB
7FE802A6 C3FF0000
EC3F0072 7FC803A6
83C10004 83E10008
CBE1000C 38210020
60000000 00000000
 

Mario Kart GP2 US Widescreen

C22C80D4 00000009
C03F0034 9421FFE0
93C10004 93E10008
DBE1000C 7FC802A6
48000009 3FAAAAAB
7FE802A6 C3FF0000
EC3F0072 7FC803A6
83C10004 83E10008
CBE1000C 38210020
60000000 00000000
 

Mario Kart GP2 JPN Widescreen

C22C86EC 00000009
C03F0034 9421FFE0
93C10004 93E10008
DBE1000C 7FC802A6
48000009 3FAAAAAB
7FE802A6 C3FF0000
EC3F0072 7FC803A6
83C10004 83E10008
CBE1000C 38210020
60000000 00000000
 

Mario Kart GP unlimited card

041F5C44 60000000
Mario Kart GP 2 unlimited card

040A02F8 60000000
Mario Kart GP 2 Jap unlimited card

040A0910 60000000


F-ZERO AX
https://www.emuline.org/topic/51-emu-dolphin-50-triforce-branche-arcade-namco-sega-nintendo-gc-wii/?do=findComment&comment=144718

you can add each code individually & manualy,
 - "On Frame" codes can be added in "Patches" (use the 2 x 8 characters code only, in ex: add these 0x803D0175:byte:0x00000001)
 - "Gecko" can be added in "Gecko" Tab obviously.

copy in User Config (doing that you are adding all the codes in a row, access them in "Patches" & "Gecko" to ON/OFF them)

[Gecko]
$Widescreen
044461B4 3FE40000
$Infinite Time
0437C964 EA000000
$Infinite Energy
04C43a04 42C80000

[OnFrame]
$Advertise Sound ON
0x803D0175:byte:0x00000001
$Advertise Sound OFF
0x803D0175:byte:0x00000000
$Game Difficulty (very easy)
0x803D0176:byte:0x00000000
$Game Difficulty (easy)
0x803D0176:byte:0x00000001
$Game Difficulty (normal)
0x803D0176:byte:0x00000002
$Game Difficulty (hard)
0x803D0176:byte:0x00000003
$Game Difficulty (hardest)
0x803D0176:byte:0x00000004
$Race Mode Laps (normal)
0x803D0179:byte:0x00000000
$Race Mode Laps (set 1)
0x803D0179:byte:0x00000001
$Race Mode Laps (set 2)
0x803D0179:byte:0x00000002
$Race Mode Laps (set 3)
0x803D0179:byte:0x00000003
$Race Mode Laps (set 4)
0x803D0179:byte:0x00000004
$Race Mode Laps (set 5)
0x803D0179:byte:0x00000005
$Handicap On
0x803D132E:byte:0x00000001
$Handicap Off
0x803D132E:byte:0x00000000
 

copy in Default Config

[OnFrame]
$Disable Motor Setup (Rev. D)
0x8024E034:dword:0x80180D5C
0x8024E038:dword:0x80180BC0
$Disable Motor Setup (Rev. E)
0x8024E4B4:dword:0x801812E8
0x8024E4B8:dword:0x8018114C
