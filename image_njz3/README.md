Distribution Sega Racer 2022-2023 - njz3


# A propos

Cette image disque est basée sur un Windows 10 dont la configuration a été adaptée aux racecabs.
Elle propose un Hyperspin basé sur Maximum Car de HFS Play, avec la plupart des jeux et emulateurs
pré-configurés pour être jouables immédiatement en mode retour de force.
Les dernières versions des émulateurs sont utilisés, en particulier :
- MAME pour les jeux anciens, ou ceux des générations 90/2000 de Namco ou Taito par exemple.
- Nebula model 2 pour Sega Model 2
- Supermodel pour Sega Model 3
- Fycast pour Naomi 1/2 et Atomiswave
- Demul pour les jeux Gaelco ou Hikaru
- Dolphin pour les jeux Triforce
- Teknoparrot pour les jeux sur plateforme PC

Le retour de force est soit natif à la plateforme ou à l'émulateur (model2, supermodel), soit généré par le 
FFB plugin de Boomslangnz. Il a été réglé dans le BackForceFeeder afin de restituer au plus juste les effets
originaux quand c'est possible.
Le mapping des boutons et des axes par défaut est actuellement celui de ma borne Le Mans à savoir 1 volant 
simple, 2 pédales, 1 Start, 2 view buttons, 1 shifter Up/Down.
Je laisse à chacun le soin de refaire le mapping selon sa borne via mon soft BackforceFeeder en suivant le 
nommage déjà pré-établi pour les boutons de chaque jeu.

La distribution fonctionne en mode FullHD (1920x1080) sur l'ensemble des jeux. 
En se limitant aux jeux MAME, model 1/2/3 et Flycast (Naomi) la distribution peut fonctionner en 24 kHz à 
l'aide du videoamp en 1024x768i ou 1024x384p, ou en 15 kHz avec le videoamp en mode 1280x240p ou 1280x480i.


# Configuration Hardware

IMPORTANT: Au premier démarrage, laisser le temps à Windows de démarrer puis installer vos drivers.

Si vous pouvez connecter votre PC à internet, faites Windows Update pour récupérer vos drivers automatiquement.
Le SSD est prévu pour fonctionner sur un PC avec :
- un processeur intel 4th gen (ou plus récent), ou un AMD Ryzen.
- 4GB de RAM minimum
- une carte graphique type Nvidia 1030 ou plus récent (1050Ti recommandé)
- une souris ou un clavier USB branché en permanence (ceci afin de pouvoir utiliser la fonction d'émulation de clavier DInput)
- soit un moniteur LCD FullHD pour profiter de l'ensemble des jeux, soit un moniteur CRT supportant le 1024x768 (31kHz ou 24kHz entrelacé) pour pratiquement tous les jeux. 
Une edition spécifique 15kHz en 1280x240p ou 1280x480i en mode "stretch" est possible avec moins de jeux (uniquement MAME, model 1/2/3 et Naomi via Flycast).


# Configuration Windows

## Reseau

IP: 192.168.1.201 ou 202 ou 203, 204, .. (multi)
Masque: 255.255.255.0
Mettre réseau privé et désactiver le Firewall


## Softs pré-installés

Le chemin C:\Racecab\Utils est ajouté dans la variable d'environement PATH du système.
Sont pré-installés :
- Les redistribuables VC Runtime Visual C++ (x86 et x64) en version 2010 (vcr100), 2012 (vcr110), 2013 (vcr120), 2015-2022 (vcr140).
- Dans les composants Windows (ajout/suppresion de composants) : DirectX (ajout composants graphiques windows), DirectPlay (ajout legacy componants/DirectPlay), Lecteur Multimedia
- La font BebasNeue.ttf pour RocketLauncher
- Les utilitaires comme VLC, TightVNC, WinMerge, Putty, Teamviewer, Firefox.
- vJoy (3 axes, 32 boutons, tous effects actifs), BFF
- Si vous voulez passer en mode TESTSIGN ON (pour vjoy non signé sous Windows 11 par exemple), utiliser Universal Watermark Disabler
- dk2win3264_8.22.26.exe (driver dongle de licence) pour avoir le mode test dans le jeu Sega Racing Classic
- rapture3dgame_2.7.4_win.exe (driver son 3D) pour Sega Showdown
- wmv9VCMsetup.exe (decoder VM9 pour windows media player) pour Storm Racer G


## Mots de passe et prise en main à distance

Par défaut, Teamviewer et TightVNC (mode serveur) sont préinstallés.
Le mot de passe de session pour l'utilisateur Racecab (admin) est "racecab"
Le mot de passe pour Teamviewer est "Racecab22!"
Le mot de passe pour VNC est "racecab"


## FFB dans les émulateurs

En cas de changement ou de ré-installation de vjoy, re mettre vJoy en volant 
à retour de force via le plugin FFB dans :
C:\Racecab\Emulators\Demul_07a_[180428]_Gaelco
C:\Racecab\Emulators\Demul_07a_[180428]_Gaelco_SD
C:\Racecab\Emulators\Demul_07a_[180428]_Hikaru
C:\Racecab\Emulators\Flycast
C:\Racecab\Emulators\Flycast LINK
C:\Racecab\Emulators\Mame
C:\Racecab\Emulators\Mame LINK
C:\Racecab\Emulators\Model2 v1.1a
C:\Racecab\Emulators\Model2 v1.1a LINK
C:\Racecab\Emulators\Supermodel
C:\Racecab\Emulators\Supermodel LINK

Teknoparrot:
C:\Racecab\Games\Batman - Raw Thrills PC Based\ZeusSP
C:\Racecab\Games\Battle Gear 4 Tuned 2.8 - Taito Type X +
C:\Racecab\Games\Battle Gear 4 Tuned 2.8 Professional Edition - Taito Type X +
C:\Racecab\Games\Chase H.Q. 2 - Taito Type X 2
C:\Racecab\Games\Daytona Championship USA\Sega\Daytona
C:\Racecab\Games\Daytona Championship USA New Season Edition\Sega\Daytona
C:\Racecab\Games\Dirty Drivin - Raw Thrills PC Based
C:\Racecab\Games\Ford Racing Full Blown - SEGA Arcade PC Based\FordRacing
C:\Racecab\Games\GTI Club Super Mini Fiesta - Konami PC Based
C:\Racecab\Games\H2 Overdrive - Raw Thrills PC based
C:\Racecab\Games\Initial D 4 - SEGA Lindbergh
C:\Racecab\Games\Initial D 4 Export (Fr Traduction) - SEGA Lindbergh
C:\Racecab\Games\Initial D 5 Export - SEGA Lindbergh
C:\Racecab\Games\Initial D 6 AA - SEGA Ringedge
C:\Racecab\Games\Initial D 7 AAX - SEGA Ringedge
C:\Racecab\Games\Initial D 8 Infinity - SEGA Ringedge
C:\Racecab\Games\Initial D Arcade Stage Zero v.2.30 - SEGA NU
C:\Racecab\Games\Mario Kart Arcade GP DX (V1.10 - Mod FR 1h) - Namco ES3
C:\Racecab\Games\Outrun 2 SP SDX - SEGA Lindbergh\disk0\Jennifer
C:\Racecab\Games\R-Tuned Ultimate Street Racing - SEGA Lindbergh


Lancer MAME, vérifier qu'un jeu se lance.
Lancer Teknoparrot, vérifier qu'un jeu se lance.


# Changement de configurations vidéo

L'image standard contient des configurations d'émulateurs pour fonctionner en mode FullHD 1080p et il est
nécessaire de les changer pour changer de mode vidéo.

## FullHD 1080p

Tous les jeux fonctionnent en Full HD.

### Flycast

Commenter/décommenter la ligne FLYCAST_OPTIONS dans le fichier :
C:\Racecab\Emulators\Flycast\flycast_options.bat

### Model 2

Copier les scripts et le fichier :
C:\Racecab\Emulators\Flycast\flycast_options.bat


## CRT 1024x768i (Videoamp 24Hz)

Seuls les jeux : MAME, model 2, model 3 et Naomi (Flycast) fonctionnent.

## CRT 1024x384p (Videoamp 24Hz)

Seuls les jeux : MAME, model 2, model 3 et Naomi (Flycast) fonctionnent.

## CRT 1280x240p (Videoamp 15Hz)

Seuls les jeux : MAME, model 2, model 3 et Naomi (Flycast) fonctionnent.

# Pour ajouter un jeu 1P


## Stockage du jeu

Mettre le jeu dans un dossier sous C:\Racecab\Games (si natif windows ou 
teknoparrot) ou directement dans C:\Racecab\Emulators\XXX\roms pour une
rom ou jeu émulé par XXX.


## Batch de lancement

Comme pratiquement chaque jeu a une configuration propre pour le FFB ou les
boutons, il est conseillé de faire un fichier .bat pour chaque jeu, qui sera
placé dans le dossier du jeu ou de l'émulateur qui va le lancer.

Nommer votre fichier .bat de manière unique et identifiable facilement.
Si possible, prendre un nom sans espace et qui correspont à un nom de rom unique.
Par exemple : "daytonas.bat" dans le dossier de "C:\Racecab\Emulators\Model2 v1.1a"
(rom "daytonas" pour le jeu Daytona Saturn Ads).

Au besoin, placez les arguments dont vous avez besoin dans le .bat.
Des utilitaires dans C:\Racecab\Utils vous permettent de faire des actions de
bases, comme lancer un emulateur, appuyer sur une touche, tuer un process, changer
de résolution, etc.
En particulier, je recommande de mettre la fenetre en mode "minimized" dès le
lancement et de donner un titre de fenetre (via la commande TITLE) qui soit
unique pour le jeu, afin que le BackForceFeeder puisse identifier quel jeu est
lancé.

Vérifier à la main que le jeu se lance via votre .bat.


## Configuration Hyperspin et RocketLauncher

- Mettre une image ronde dans le dossier 
C:\Racecab\Hyperspin\Media\1P\images\artwork4
avec exactement le nom de votre .bat (exemple : 'daytonas.png')

- Mettre l'image de titre (max 400 pixels de large) dans le dossier
C:\Racecab\Hyperspin\Media\1P\images\wheel
avec exactement le nom de votre .bat (exemple : 'daytonas.png')

- Mettre la video au format mp4 ou flv dans le dossier 
C:\Racecab\Hyperspin\Media\1P\video
avec exactement le nom de votre .bat (exemple : 'daytonas.mp4')

- Ajouter les balises xml dans la database Hyperspin qui est dans le fichier
C:\Racecab\Hyperspin\Databases\1P\1P.xml
en prenant exactement le nom de votre .bat pour la balise 'name'.

Par exemple :

<game name="daytonas" index="true" image="c">
	<description>Daytona USA (Saturn Ads)</description>
	<cloneof></cloneof>
	<crc></crc>
	<manufacturer>Sega, *FFB*</manufacturer>
	<year>1993</year>
	<genre></genre>
</game>

- Copier le fichier 1P.xml de la database Hyperspin vers la database
RocketLauncherUI
C:\Racecab\Hyperspin\RocketLauncher\RocketLauncherUI\Databases\1P\1P.xml

- Declarer quel emulateur et systeme utiliser pour votre jeu. A part pour les
jeux MAME, nous n'utiliserons que le module PCLauncher (lancement de fichiers 
.exe ou .bat). Ainsi, ajouter les balises pour votre jeu dans le fichier
C:\Racecab\Hyperspin\RocketLauncher\Settings\1P\Games.ini

Par exemple : 
[daytonas]
Emulator=PCLauncher
System=1P

- Ajouter la ligne qui permet de lancer votre .bat et les options de lancement
via le module PCLauncher.ahk dans le fichier 
C:\Racecab\Hyperspin\RocketLauncher\Modules\PCLauncher\1P.ini

Par exemple:

[daytonas]
Application=..\..\Emulators\Model2 v1.1a\Emulator_multicpu.exe
Parameters=daytonas
AppWaitExe=Emulator_multicpu.exe

Les options du module PCLauncher de RocketLauncher sont données en entête de
fichier dans la balise [Example].

|Attention:|
------------
Pour temporairement enlever un jeu dans le fichier, il faut mettre des '#' au
début de ligne dans C:\Racecab\Hyperspin\RocketLauncher\Modules\PCLauncher\1P.ini
et surtout supprimer les [] autour du nom du jeu, sinon RocketLauncher va
quand même le détecter. 

Par exemple, pour commenter daytonas, mettre :
# daytonas                    <= sans les []
#Application=..\..\Emulators\Model2 v1.1a\Emulator_multicpu.exe
#Parameters=daytona
#AppWaitExe=Emulator_multicpu.exe


Une fois configuré, tester si votre jeu se lancer via RocketLauncher. Démarrer
C:\Racecab\Hyperspin\RocketLauncher\RocketLauncher.exe
Puis prendre le system 1P et taper le nom de votre jeu (par exemple 'daytonas').

Lancer Hyperspin et faire la même chose en testant si votre jeu se lance.

## Configuration BackForceFeeder

Ajouter un nouveau control set en duplicant un existant.

Pour automatiquement détecter le jeu dans le BFF, préciser soit le nom de l'exécutable
et le titre de la fenetre principale, soit dans le fichier .bat ajouter un TITLE
avec un titre unique ou le nom du fichier .bat. Dans ce cas, dans le BFF 
indiquer 'conhost|cmd' dans l'exe, et en nom de fenetre ce que vous avez mis en
TITLE de votre .bat (en général nom du fichier .bat).

Lancer le jeu via le .bat et verifier que le BFF bascule vers le control set
(vous devez avoir coché l'autodetection dans App&Hardware pour que cela marche).


# Pour ajouter un jeu MULTI

Procéder exactement comme en 1P mais utiliser les noms de dossiers MULTI, et
les fichiers MULTI.ini.

Penser à faire un .bat different si besoin pour distinguer le 1P du MULTI.

En résumé :

1) Ajouter les images et video dans (avec un nom unique): 
C:\Racecab\Hyperspin\Media\MULTI

2) Editer la database Hyperspin (fichier xml) ici :
C:\Racecab\Hyperspin\Databases\MULTI\MULTI.xml

3) Copier la databse Hyperspin (fichier xml) vers celle de RocketLauncherUI :
C:\Racecab\Hyperspin\RocketLauncher\RocketLauncherUI\Databases\MULTI

4) Ajouter la decription de votre jeu (emulateur et system) dans :
C:\Racecab\Hyperspin\RocketLauncher\Settings\MULTI\Games.ini

5) Mettre la commande de lancement de votre jeu dans :
C:\Racecab\Hyperspin\RocketLauncher\Modules\PCLauncher\MULTI.ini

6) Si besoin, configurer le BFF pour détecter votre .bat ou votre jeu et 
configurer les controles, les lampes ou le retour de force.


# Configuration du BackForceFeeder

Le logiciel BackForceFeeder est pré-installé et possède une configuration par défaut
pour la plupart des jeux.
Le logiciel nécessite un fichier licence.dat pour être activé, qui est fourni sur
demande par email à bff.register@gmail.com en indiquant votre ID de machine et 
en joignant un don paypal à la même adresse (un minimum de 20€ est demandé).
Le fichier de licence est à placer dans le répertoire :
C:\Users\Racecab\Documents\BackForceFeeder

## Fichiers de configuration

Les configurations sont stockées dans le répertoire :
C:\Users\Racecab\Documents\BackForceFeeder

Le sous-dossier ControlSets contient en particulier les configurations pour chaque jeu.
Vous ne pouvez pas éditer à la main ces fichiers si le logiciel fonctionne, il faut
d'abord le fermer pour pouvoir modifier les fichiers.


# Notes/FAQ

## Jeux Teknoparrot

### Outrun2 et autres jeux Lindberg

Prévoir de copier les fichiers EPROM single/multi dans C:\Users\Racecab\AppData\Roaming\TeknoParrot

### Raw Thrills PC Based

La plupart des jeux Raw Thrills necessite d'etre à la racine de C:\ dans un repertoire commencant par "rawart", par
exemple, Fast n Furious serie dans c:\rawart FnF
Winter X Games Snocross obligatoirement dans C:\rawart Winter X Games Snocross\ sinon image qui fait du flickering.
SuperBikes obligatoirement dans C:\rawart SuperBikes\ sinon erreur CRC
SuperBikes 2 obligatoirement dans C:\rawart SuperBikes2\ sinon erreur CRC
