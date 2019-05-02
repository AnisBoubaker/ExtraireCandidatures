# ExtraireCandidatures

## Description
Script qui extrait les fichiers des candidatures reçues depuis les fichiers MSG. 
Un dossier est créé pour chaque dossier MSG dans lequel on retrouve:

- Le contenu du courriel au format texte (fichier message_courriel.txt)
- Le fichiers attachés. Si, parmi les fichiers, se trouvent des fichiers compressés (rar ou zip), 
  ils seront décompressés et le fichier compressé sera supprimé.

## Dépendances
Pour exécuter ce script, il faut disposer de munpack (packetage mpack), 
msgconvert (packetage libemail-outlook-message-perl), unzip et unrar.

## Usage: 
Copier le script dans le dossier contenant les fichiers MSG, lui donner les droits d'exécution et l'éxécuter.

