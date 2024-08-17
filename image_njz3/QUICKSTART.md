Distribution Sega Racer 2022-2024 - njz3
----------------------------------------

An up-to-date online version of the QUICKSTART and README files are available here:
Une version en ligne à jour du fichier README est disponible ici :

https://github.com/njz3/BFF_gameassets/blob/main/image_njz3/README.md
https://github.com/njz3/BFF_gameassets/blob/main/image_njz3/QUICKSTART.md

# ENGLISH

## MINIMUM PC REQUIREMENTS

The SSD is designed to run on a PC with:
- an intel 4th gen (or later) processor, or an AMD Ryzen or later.
- 4GB RAM minimum
- Nvidia 1030 graphics card or higher (1050Ti recommended)
- a permanently connected USB keyboard or mouse (in order to be able to use the
use the DInput keyboard emulation function)
- either a FullHD LCD monitor to enjoy the full range of games, or a 
CRT monitor supporting 1024x768.
- if you're using a VideoAmp card, you can use either the 31kHz or 24kHz 
interlaced modes for all games except Teknoparrot HD, and a specific 
15kHz edition in 1280x240p or 1280x480i “stretch” mode is possible with fewer 
games (only MAME, model 1/2/3 and Naomi via Flycast).

## DISC DRIVE INSTALLATION

Your computer must be switched off and the power cord removed to avoid any 
electric shock.
Open your computer and fix the SATA disk drive into your computer. Connect it
using a SATA cable to an available port on your motherboard and connect the
other side to the drive at the small SATA connector for data.
Then connect the drive to your ATX power supply using the second, larger 
connector, taking care not to break the connectors.
Close your computer and move on to the next BIOS configuration step.

## MOTHERBOARD BIOS CONFIGURATION

**IMPORTANT**
To enable disks to boot, you need to configure your motherboard BIOS to boot
on the SATA port to which the drive is connected, disable “Secure Boot” and 
use the “Legacy BIOS” (MBR) boot mode, not UEFI.

To configure the BIOS, you generally need to press a keyboard key at the very
first moment your computer is switched on. A very quick message at boot will
display which key to press. Depending on the motherboard, the BIOS 
configuration menu can be accessed by pressing the keys 
"F1", "F2", "F8", "F10", "F12", or "DELETE", "BACKSPACE".

Once the BIOS configuration menu is open, look for the boot disk and select 
the SATA port to which the drive is connected.

Then go to the boot type configuration page, and disable the “Secure Boot” mode
if it is active.
The disk image is designed to run in MBR mode, so don't use UEFI mode and select
“Legacy BIOS” (MBR) boot mode.

## FIRST BOOT

On first start-up, give Windows time to boot up and install your drivers. Once 
the disk has booted up, you should see the Hyperspin game selection screen.
Exit Hyperspin by pressing “ESC” to go to the "Exit?" menu, then "V" to confirm
"Exit". You'll now have the Windows desktop and can continue the
configuration.

If you can connect your PC to the Internet, first run Windows Update to get 
your drivers automatically.

## NETWORK CONFIGURATION (MULTIPLAYER/LINK MODE)

Multiplayer (or link) mode is already configured for the images.
You can either link 2 computers directly (no need for a crossover cable) without 
internet access, or use a switch to link more than 2 computers, or connect your
computers to a home network and the Internet.
In all cases, you'll need to reconfigure your network settings as these are
usually lost once the disk has been installed in your computer.
Go to the network configuration page and set the following parameters 
parameters:

- IPv4 address: 192.168.1.4 for cab 1 (or 192.168.1.5 for cab 2, and .6
or .7, or .X ... depending on your multi-cab setup). Some games, such as Daytona 2
support up to 8 or 16 machines in multiplayer mode.
- Subnet mask: 255.255.255.0
- Gateway: 192.168.1.254 (can be changed to 192.168.1.1 depending on your LAN)
- DNS: 8.8.8.8 or 8.8.4.4 (Google DNS)
- Broadcast address: 192.168.1.255

Also in network configuration, set private network and disable the
Firewall.

> **Note:**
For network gaming on model 2 emulator (Sega Rally, Daytona 1, etc.) you need
to enable support for long frames (3kB) either via an option on your network 
card driver, or enable the "Jumbo Frames" (MTU >3kB) option in the Ethernet
board adapter properties, and have a 1GBit Ethernet switch that supports 
"Jumbo Frames".

![Network configuration](Utils/images/networkconfig.png “Network configuration”).

## PASSWORD AND REMOTE CONNECTION

By default, Teamviewer and TightVNC (server mode) are preinstalled and enabled. 
Please note: it is your responsibility to protect your network from external 
access.

The session password for the Racecab (admin) user is `racecab`.
The password for VNC is `racecab`.

# FRANCAIS

## CONFIGURATION MINIMALE PC

Le SSD est prévu pour fonctionner sur un PC avec :
- un processeur intel 4th gen (ou plus récent), ou un AMD Ryzen ou plus récent.
- 4GB de RAM minimum
- une carte graphique type Nvidia 1030 ou plus récent (1050Ti recommandé)
- une souris ou un clavier USB branché en permanence (ceci afin de pouvoir
utiliser la fonction d'émulation de clavier DInput)
- soit un moniteur LCD FullHD pour profiter de l'ensemble des jeux, soit un 
moniteur CRT supportant le 1024x768.
- si vous utilisez une carte VideoAmp il est possible d'utiliser les modes
31kHz ou 24kHz entrelacé pour tous les jeux hors jeux Teknoparrot HD, et une 
édition spécifique 15kHz en 1280x240p ou 1280x480i en mode "stretch" est 
possible avec moins de jeux (uniquement MAME, model 1/2/3 et Naomi via Flycast).

## INSTALLATION DU DISQUE

Votre ordinateur doit être éteint et le cordon secteur retiré pour éviter tout
choc électrique.
Ouvrez votre ordinateur et fixer le disque SATA dans votre ordinateur. Reliez 
ce dernier à l'aide d'un câble SATA sur un port disponible de votre carte mère 
et connectez l'autre côté au disque au niveau du petit connecteur SATA pour les 
données.
Reliez ensuite le disque à votre alimentation ATX en utilisant le second 
connecteur, plus grand, en faisant attention à ne pas casser les connecteurs.
Refermez votre ordinateur et passez à l'étape suivante de configuration du BIOS.

## CONFIGURATION DU BIOS DE LA CARTE MERE

**IMPORTANT**
Pour que les disques puissent démarrer, vous devez configurer votre BIOS de 
carte mère pour démarrer sur le port SATA sur lequel est branché le disque, 
désactiver le "Secure Boot" et utiliser le mode de démarrage "Legacy BIOS" 
(MBR), et non UEFI.

Pour configurer le BIOS, il faut en général presser une touche clavier au tout
premier instant d'allumage de votre ordinateur. Un affichage très rapide à 
l'allumage vous indique en général la touche à presser. Ainsi, selon les cartes 
mères, le menu de configuration du BIOS est accessible en pressant les touches 
"F1", "F2", "F8", "F10", "F12", ou encore "SUPPR", "RETOUR ARRIERE".

Une fois le menu de configuration du BIOS ouvert, cherchez la page de 
configuration du disque de démarrage, et sélectionner le port SATA sur lequel
le disque est connecté.

Allez ensuite dans la page de configuration du type de démarrage, et désactiver
le mode "Secure Boot" s'il est actif. 
L'image disque est prévue pour fonctionner en mode MBR, ainsi n'utilisez pas le 
mode UEFI et sélectionnez le mode de démarrage "Legacy BIOS" (MBR).

## PREMIER DEMARRAGE

Au premier démarrage, laisser le temps à Windows de démarrer puis installer
vos drivers. 
Une fois le disque démarré, vous devrier avoir l'écran Hyperspin de sélection
de jeu. Quittez Hyperspin en faisant "ESC" pour aller au menu "Exit?", puis "V"
pour confirmer "Exit". Vous allez à présent avoir le bureau Windows et vous 
pouvez poursuivre la configuration.

Si vous pouvez connecter votre PC à internet, lancez en premier Windows Update
pour récupérer vos drivers automatiquement.

## CONFIGURATION RESEAU (MODE MULTIPLAYER/LINK)

Le fonctionnement en multiplayer (ou link) est déjà prévu dans les images.
Vous pouvez soit relié en direct 2 ordinateurs (cable croisé inutile) sans 
avoir besoin d'accès à internet, soit utiliser un switch pour relier plus de 2
ordinateurs, ou relier vos ordinateurs à un réseau domestique et à internet.
Dans tous les cas, il est nécessaire de re-configurer les paramètres réseau
car ceux-ci sont en général perdus après installation du disque dans votre 
ordinateur.
Allez dans la page de configuration du réseau et définissez les paramètres 
suivants :

- adresse IPv4: 192.168.1.4 pour cabine 1 (ou 192.168.1.5 pour cabine 2,et .6
ou .7, ou .X .. selon la cabine en multi). Certains jeux comme Daytona 2
supportent jusqu'à 8 ou 16 machines en multiplayer.
- Masque de sous-réseau: 255.255.255.0
- Passerelle : 192.168.1.254 (modifable selon votre réseau LAN en 192.168.1.1)
- DNS : 8.8.8.8 ou 8.8.4.4 (DNS de Google)
- Broadcast address: 192.168.1.255

Toujours dans la configuration réseau, mettre réseau privé et désactivez le
Firewall.

> **Note:**
Pour le jeu en réseau sur model 2 emulator (Sega Rally, Daytona 1, etc.)
if faut impérativement activer le support des trames de longues taille (3kB)
soit via une option de votre carte réseau, soit activer l'option "Jumbo Frames"
dans votre carte Ethernet (MTU >3kB) et avoir un switch Ethernet 1GBit qui 
supporte les "Jumbo Frames".

![Configuration réseau](Utils/images/networkconfig.png "Configuration réseau").

## MOT DE PASSE ET "REMOTE CONNECTION"

Par défaut, Teamviewer et TightVNC (mode serveur) sont préinstallés et le 
bureau à distance est activé. 
Attention, il est de votre responsabilité de protéger votre réseau d'un accès
extérieur.

Le mot de passe de session pour l'utilisateur Racecab (admin) est `racecab`
Le mot de passe pour VNC est `racecab`
