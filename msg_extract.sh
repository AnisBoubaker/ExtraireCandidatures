#!/bin/bash

# <description>
# Script qui extrait les fichiers des candidatures reçues depuis les fichiers MSG. 
# Un dossier est créé pour chaque dossier MSG dans lequel on retrouve:
# - Le contenu du courriel au format texte (fichier message_courriel.txt)
# - Le fichiers attachés. Si, parmi les fichiers, se trouvent des fichiers compressés
#   (rar ou zip), ils seront décompressés et le fichier compressé sera supprimé.
#
# Dépendances: Pour exécuter ce script, il faut disposer de munpack (packetage mpack), 
#  msgconvert (packetage libemail-outlook-message-perl), unzip et unrar.
#
# Usage: 
# Copier le script dans le dossier contenant les fichiers MSG, lui donner les droits 
# d exécution et l éxécuter.



# Vérification des dépendances
if ! [ -x "$(command -v msgconvert)" ]; then
        echo "Erreur: Vous devez installer msgconvert (sudo apt install libemail-outlook-message-perl libemail-sender-perl)" >&2
        exit 1
fi

if ! [ -x "$(command -v munpack)" ]; then
	echo "Erreur: Vous devez installer mpack (sudo apt install mapck)" >&2
	exit 1
fi
if ! [ -x "$(command -v unzip)" ]; then
        echo "Avertissement: unzip introuvable, le script ne décompressera pas les fichiers compressés" >&2
fi
if ! [ -x "$(command -v unrar)" ]; then
        echo "Avertissement: unrar introuvable, le script ne décompressera pas les fichiers compressés" >&2
fi


#conversion des fichiers MSG en EML
msgconvert *.msg >/dev/null 2>/dev/null

for file in ./*.eml;
do
	#Parsing du nom de fichier pour créer un dossier de même nom (sans l'exeention)
	nom_dossier=${file##*/}
	nom_dossier=${nom_dossier%.eml}
	nom_dossier=${nom_dossier// /_}
	#Suppression du dossier si il existe
	rm -Rf ./$nom_dossier 2>/dev/null
	#Création du dossier
	mkdir $nom_dossier
	#Extraction du contenu du fichier eml dans le nouveau dossier
	cp "$file" $nom_dossier
	munpack -f -q -C $nom_dossier "$file" >/dev/null
	rm $nom_dossier/"$file"
	rm $nom_dossier/part1
	mv $nom_dossier/part1.desc $nom_dossier/message_courriel.txt
	for un_zip in ./$nom_dossier/*.zip;
	do
		[ -f "$un_zip" ] || continue
		unzip -q $un_zip -d ./$nom_dossier
		rm $un_zip 
	done

	for un_rar in ./$nom_dossier/*.rar;
	do
		[ -f "$un_rar" ] || continue
		unrar x $un_rar ./$nom_dossier >/dev/null
		rm $un_rar
	done
done

rm *.eml
