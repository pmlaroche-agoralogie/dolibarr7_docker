#!/bin/bash

# Script d'initialisation du projet Dolibarr Docker
# Usage: ./init.sh

set -e

echo "=== Initialisation du projet Dolibarr Docker ==="

# Répertoire cible pour les données persistantes
TARGET_DIR="/home/agoralogie/Nextcloud/Documents/Administration_agoralogie/dolibarr21"

# Création des répertoires nécessaires
echo "Création des répertoires de données..."
mkdir -p "$TARGET_DIR/documents"
mkdir -p "$TARGET_DIR/mysql_data"

# Copie des documents existants si le répertoire source existe
SOURCE_DOCS="../dolibarr2021.agoralogie.fr/documents"
if [ -d "$SOURCE_DOCS" ] && [ "$(ls -A $SOURCE_DOCS 2>/dev/null)" ]; then
    echo "Copie des documents existants..."
    cp -r "$SOURCE_DOCS"/* "$TARGET_DIR/documents/" 2>/dev/null || true
    echo "Documents copiés avec succès."
else
    echo "Aucun document source trouvé ou répertoire vide."
fi

# Définir les permissions
echo "Configuration des permissions..."
chmod -R 755 "$TARGET_DIR/documents"
chmod -R 755 "$TARGET_DIR/mysql_data"

# Création du fichier .env s'il n'existe pas
if [ ! -f ".env" ]; then
    echo "Création du fichier .env..."
    cp .env.example .env
    echo "Fichier .env créé. Pensez à modifier les mots de passe !"
fi

echo ""
echo "=== Initialisation terminée ==="
echo ""
echo "Pour démarrer le projet :"
echo "  cd dockerfile"
echo "  docker-compose up -d"
echo ""
echo "Accès :"
echo "  - Dolibarr : http://localhost:8080"
echo "  - phpMyAdmin : http://localhost:8081"
echo ""
echo "IMPORTANT: Vérifiez et modifiez le fichier conf.php de Dolibarr"
echo "pour pointer vers la bonne base de données (host: db)"
