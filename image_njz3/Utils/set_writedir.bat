:: Dossier d'ecriture unique pour les emulateurs (bornes sous UWF).
::
:: Laisser WRITEDIR_ROOT VIDE pour garder le comportement d'origine : chaque
:: emulateur ecrit dans son propre dossier, et la bascule single/link/cabine
:: reste assuree par l'echange de dossiers de Build-Config.
::
:: Renseigner WRITEDIR_ROOT pour activer le dossier d'ecriture des lanceurs de
:: linuxloader, windowsloader, Flycast, MAME (sauf Mame Namco LINK, 0.251),
:: sm2-emu et Supermodel. Le chemin doit etre la SEULE exclusion UWF du disque.
:: Un sous-dossier par emulateur et par identite :
::   <WRITEDIR_ROOT>\<emulateur>_single         lanceurs solo
::   <WRITEDIR_ROOT>\<emulateur><CAB_ID>        lanceurs link (set_cab_id.bat)
:: Au premier lancement, l'emulateur l'amorce lui-meme depuis ses reglages et
:: ses NVRAM en place, que Build-Config pose pour la cabine de la machine ;
:: quand il en pose d'autres (changement de cabine, -ForcerNvram), il vide le
:: sous-dossier correspondant (colonne WRITEDIR de targets.csv).
::
:: Actif depuis le 24/10/2026 pour linuxloader, le 28/10/2026 pour les autres.
:: Pour revenir au comportement d origine : set WRITEDIR_ROOT=
set WRITEDIR_ROOT=C:\Racecab\Saves
