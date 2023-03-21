# ventura

## Tools

- https://github.com/corpnewt/MountEFI
- https://github.com/corpnewt/ProperTree
- https://github.com/corpnewt/GenSMBIOS
- https://github.com/corpnewt/SSDTTime

## BIOS

A désactiver :

- Fast Boot
- Secure Boot
- Serial/COM Port
- Parallel Port
- VT-d 
- Compatibility Support Module (CSM)
- Intel SGX (?)
- Intel Platform Trust (?)
- CFG Lock

A activer :

- Above 4G Decoding
- EHCI/XHCI Hand-off
- DVMT Pre-Allocated(iGPU Memory): 64MB or higher
- SATA Mode: AHCI

## Préparation de la Clef USB

**1. Télécharger l'installer de macOS :**

```
$ mkdir -p ~/macOS-installer && cd ~/macOS-installer && curl https://raw.githubusercontent.com/munki/macadmin-scripts/main/installinstallmacos.py > installinstallmacos.py && sudo python3 installinstallmacos.py
```

L'image se trouvera dans `~/macOS-installer/<macOS_version>.img`. Il faudra ensuite monter le `.img` pour trouver le `.app` d'installation qu'il faudra mettre dans `/Applications`.

**2. Formatter une clef USB avec :**

```
$ diskutil list
$ diskutil eraseDisk ExFAT MyVolume </dev/diskID>
```

**3. Flasher la clef USB avec :**

```
$ sudo "/Applications/Install <macOS version>/Contents/Resources/createinstallmedia" --volume "/Volumes/MyVolume"
```

## Préparer le dossier EFI

Vous pouvez soit repartir du répertoire EFI de ce repository, soit recréer un nouveau répertoire EFI, comme montré ci-dessous.

**1. Télécharger les fichiers de base de OpenCore : https://github.com/acidanthera/OpenCorePkg/releases/**

Il faut garder le répertoire `X64/EFI` et le fichier `Docs/Sample.plist` en les mettant à la racine du répertoire dézippé, et en supprimant tout le reste.

**2. Télécharger les Drivers**

Les Drivers sont à mettre dans `EFI/OC/Drivers`. Il faut uniquement conserver `HfsPlus.efi` et `OpenRunetime.efi`, le reste doit être supprimé.

- https://github.com/acidanthera/OcBinaryData/blob/master/Drivers/HfsPlus.efi

**3. Télécharger les Kext**

Les Kext sont à mettre dans `EFI/OC/Kexts`.

- https://github.com/acidanthera/AppleALC/release
- https://github.com/acidanthera/IntelMausi
- https://github.com/acidanthera/Lilu/releases
- https://github.com/acidanthera/VirtualSMC/releases
- https://github.com/acidanthera/WhateverGreen/releases

**4. Build le Kext USBMap.kext**

Il faut utiliser `USBMap` (https://github.com/corpnewt/USBMap) pour mapper les ports USBs de son PC. Pas besoin d'autres Kext de type USB avec ce Kext.

- Lancer le tool avec la discovery de ports
- Generer un Fake Kext, mettre ce Fake Kext dans la partition EFI et faire un OC Snapshot
- Reboot
- Lancer le tool avec la discovery de ports
- Brancher une clef USB 2.0 ET une clef USB 3.0 dans chaque Ports, attendre 5s entre chaque branchement/debranchement de clefs
- Définir chaque type de port pour chaque entrée
- Génerer le kext

**5. Télécharger les ACPI (à mettre dans EFI/OC/ACPI)**

Build les ACPI avec SSDTTime (simple, il faut juste aller sur Linux pour génerer le fichier de base).

**6. Remplir le fichier config.plist**

- https://dortania.github.io/OpenCore-Install-Guide/config.plist/coffee-lake.html#starting-point

Il faut veiller a bien remplir le champs pour l'iGPU. Le dGPU n'est a spécifier nul part. On peut prendre en référence le fichier config.plist dans le repository.

**7. Mettre le dossier EFI dans la partition EFI**

Il ne reste plus qu'à mettre le répertoire EFI dans la partition EFI de la clef USB ; de boot sur la clef ; et de suivre les étapes de l'installation.

## Installation

Il faut formatter le SSD en APFS avec une Table de Partition GUID.

## Post-Install

Vous pouvez remplacer le dossier EFI présent dans la partition EFI du SSD par le dossier EFI_postinstall.zip présent dans le repository ; reboot ; et activer FileVault. Vous pouvez aussi manuellement effectuer ces opérations comme montré ci-dessous (effectuer les modifications dans le fichier config.plist pour activer Filevault, effectuer les opérations cosmétiques, génerer le .kext pour l'optimisation de l'energie).

- https://dortania.github.io/OpenCore-Post-Install/universal/security.html
- https://dortania.github.io/OpenCore-Post-Install/cosmetic/gui.html#setting-up-opencore-s-gui
- https://dortania.github.io/OpenCore-Post-Install/cosmetic/verbose.html#macos-decluttering
- https://dortania.github.io/OpenCore-Post-Install/universal/pm.html

## Security & Privacy

Dans les Réglages du système :

1. **Général** : Désactiver "Autoriser Handoff entre ce Mac et vos appareils iCloud".
2. **Mission Control** : Définir une touche pour Mission Control.
3. **Siri** : Désactiver Siri.
4. **Spotlight** : Désactiver tout ce qui n'est pas utile.
5. **Réseau -> Coupe-feu** : Activer le Firewall et séléctionner "Bloquer toutes les connexions entrantes" dans "Options de coupe-feu...".
6. **Sécurité et confidentialité -> FileVault** : Activer FileVault. Une fois activer, taper la commande `sudo sh -c 'pmset -a destroyfvkeyonstandby 1; pmset -a hibernatemode 25; pmset -a powernap 0; pmset -a standby 0; pmset -a standbydelay 0; pmset -a autopoweroff 0` pour augmenter la sécurité.
7. **Sécurité et confidentialité -> Général** : Mettre "Exiger le mot de passe _imédiatement_ après la suspension d'activité...".
8. **Sécurité et confidentialité -> Confidentialité** : Désactiver tout ce qui n'est pas utile.
9. **Mise à jour de logiciels** : Activer les Mises à jour automatiques.
10. **Bluetooth** : Désactiver le Bluetooth.
11. **Réseau -> Avancé... -> DNS** : Ajouter les DNS `1.1.1.1` et `1.0.0.1`.
12. **Clavier -> Texte** : Tout désactiver.
13. **Partage** : Tout désactiver. Définir le hostname de l'ordinateur.
14. **Users** : Créer un compte admin, un compte utilisateur, et désactiver le compte invité.

Dans un terminal :

1. Désactiver Captive Portal : `sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false`
2. Désactiver Crash Reporter : `sudo defaults write com.apple.CrashReporter DialogType none`
3. Désactiver ftp-proxy : `sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ftp-proxy.plist`
4. Montrer les fichiers cachés : `defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder`
5. Désactiver automount : Edit /etc/auto_master as root and comment the line beginning with /net
6. Installer de chez Objective-See : Lulu Firewall, DNSMonitor, DHS, KextWiewer, Netiquette, TaskExplorer, BlockBlock, KnockKnock
7. Block Maliciopus domain name using /etc/hosts and stevenblack/hosts github.

Pour les mises à jour macOS, dans LuLu, il faut autoriser :

- softwareupdated
- mobileassetd
- com.apple.MobileSoftwareUpdate.UpdateBrainService

## Productivity

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ brew install apktool clisp dmg2img flatbuffers flatcc gdb git gnupg graphviz htop jadx john-jumbo netcat nvm openjdk@11 pandoc python@3.11 python@3.9 smartmontools telnet wget
$ brew install --cask android-platform-tools android-studio appcleaner balenaetcher basictex deluge dhs eclipse-ide electron firefox firefox-developer-edition ghidra google-chrome jupyterlab mysqlworkbench netiquette obs onyx openoffice owasp-zap pycharm-ce raspberry-pi-imager taskexplorer textmate virtualbox visual-studio-code vlc vmware-fusion wireshark
```

## SIP

Pour activer/désactiver SIP, il faut reboot sur le disque de secours (en appuyant sur espace dans le bootloader).

Puis depuis le disque de secours, dans un Terminal :

    $ csrutil disable # désactive SIP
    $ csrutil enable  # active SIP

On peut ensuite reboot.

## Issues

**1. OpenCore Debug Mode**

Pour activer le debug mode, il faut télécharger la version DEBUG de OpenCore depuis le repository GitHub, puis remplacer dans le répertoire EFI de la clef USB les fichiers suivants :

```
- EFI/BOOT/
    - BOOTx64.efi
- EFI/OC/Drivers/
    - OpenRuntime.efi
    - OpenCanopy.efi (if you're using it)
- EFI/OC/
    - OpenCore.efi
```

**2. BlackSreen avec ProperTree**

Télécharger et installer Python depuis https://www.python.org/downloads/macos/ ; puis buildez un `.app` de ProperTree avec `Scripts/buildapp-select.command`.
