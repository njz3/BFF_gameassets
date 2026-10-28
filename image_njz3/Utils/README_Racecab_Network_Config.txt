
WINDOWS NETWORK CONFIG for RACECAB
Version: 1.0
Build date: 2025-11-05
Author: Tibal

------------------------------------------------------------
ENGLISH — USER GUIDE
------------------------------------------------------------

Overview:
This utility automates network configuration management for RaceCab systems.
It allows you to detect the active interface, apply IP configurations, back up and restore settings, and reset the network stack.

Menu Options:
B - Backup current configuration
R - Restore a saved configuration
0 - DHCP (Auto)
1–8 - Apply custom configuration (Cab1–Cab8)
S - Show current network config
C - Clean / Reset network stack
Q - Quit

Backups are saved under:
C:\Racecab\Utils\Netsh\Backups\Backup_YYYY-MM-DD_HH-MM.txt

Restore Mode:
Allows you to review backup files and open IPv4 settings (ncpa.cpl) for manual adjustment.

Clean Network Stack:
Runs:
netsh winsock reset
netsh int ip reset
ipconfig /flushdns

Use if DNS errors like "The DNS server is not responding" appear.
Reboot required after cleaning.

Custom Configurations:
Located in:
C:\Racecab\Utils\Netsh\WinNetworkConfig_CabX.txt
Example:
netsh interface ipv4 set address name="Ethernet" static 192.168.0.10 255.255.255.0 192.168.0.254
netsh interface ipv4 set dnsservers name="Ethernet" static 192.168.0.254

------------------------------------------------------------
FRANÇAIS — GUIDE UTILISATEUR
------------------------------------------------------------

Vue d’ensemble :
Cet utilitaire gère la configuration réseau pour les systèmes RaceCab.
Il détecte automatiquement l’interface active, applique des configurations IP, sauvegarde/restaure la configuration et peut réinitialiser la pile réseau.

Menu principal :
B - Sauvegarder la configuration
R - Restaurer une configuration
0 - DHCP (Auto)
1–8 - Configurations personnalisées (Cab1–Cab8)
S - Afficher la configuration actuelle
C - Nettoyer / Réinitialiser la pile réseau
Q - Quitter

Sauvegardes :
Stockées dans :
C:\Racecab\Utils\Netsh\Backups\Backup_YYYY-MM-DD_HH-MM.txt

Restauration :
Permet de visualiser le fichier de sauvegarde et d’ouvrir la fenêtre IPv4 (ncpa.cpl) pour modifier manuellement la configuration.

Nettoyage réseau :
Exécute :
netsh winsock reset
netsh int ip reset
ipconfig /flushdns

À utiliser si des erreurs DNS apparaissent :
« Le serveur DNS ne répond pas »
« Serveur DNS introuvable »
Un redémarrage est nécessaire.

Configurations personnalisées :
Situées dans :
C:\Racecab\Utils\Netsh\WinNetworkConfig_CabX.txt
Exemple :
netsh interface ipv4 set address name="Ethernet" static 192.168.0.10 255.255.255.0 192.168.0.254
netsh interface ipv4 set dnsservers name="Ethernet" static 192.168.0.254
