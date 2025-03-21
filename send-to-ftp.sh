#!/bin/bash

echo "Générateur de script de sauvegarde Minecraft vers FTP"
echo "----------------------------------------------------"

# Recueillir les informations nécessaires
read -p "Chemin vers votre serveur Minecraft: " MINECRAFT_DIR
read -p "Répertoire pour les sauvegardes: " BACKUP_DIR
read -p "Nombre de jours de conservation: " BACKUP_RETENTION
read -p "Adresse du serveur FTP: " FTP_SERVER
read -p "Nom d'utilisateur FTP: " FTP_USER
read -p "Mot de passe FTP: " FTP_PASS
read -p "Répertoire sur le serveur FTP: " FTP_DIR
read -p "Nom du script à générer: " SCRIPT_NAME

# Créer le script
cat > "$SCRIPT_NAME" << EOF
#!/bin/bash

# Configuration
MINECRAFT_DIR="$MINECRAFT_DIR"
BACKUP_DIR="$BACKUP_DIR"
FTP_SERVER="$FTP_SERVER"
FTP_USER="$FTP_USER"
FTP_PASS="$FTP_PASS"
FTP_DIR="$FTP_DIR"
BACKUP_RETENTION=$BACKUP_RETENTION

# Création du répertoire de backup
mkdir -p \$BACKUP_DIR

# Date du jour pour le nom du fichier
DATE=\$(date +"%Y-%m-%d")
BACKUP_FILE="minecraft_backup_\$DATE.tar.gz"

echo "Création de la sauvegarde..."
tar -czf "\$BACKUP_DIR/\$BACKUP_FILE" -C "\$(dirname "\$MINECRAFT_DIR")" "\$(basename "\$MINECRAFT_DIR")"

echo "Envoi de la sauvegarde vers le serveur FTP..."
ftp -n \$FTP_SERVER << EOFTP
user \$FTP_USER \$FTP_PASS
binary
cd \$FTP_DIR
put \$BACKUP_DIR/\$BACKUP_FILE
bye
EOFTP

if [ \$? -eq 0 ]; then
    echo "Sauvegarde envoyée avec succès!"
else
    echo "Erreur lors de l'envoi de la sauvegarde!"
    exit 1
fi

echo "Suppression des anciennes sauvegardes locales..."
find \$BACKUP_DIR -name "minecraft_backup_*.tar.gz" -mtime +\$BACKUP_RETENTION -delete

echo "Processus de sauvegarde terminé!"
EOF

# Rendre le script exécutable
chmod +x "$SCRIPT_NAME"

echo "Script créé avec succès: $SCRIPT_NAME"
echo "Vous pouvez maintenant l'exécuter avec: ./$SCRIPT_NAME"
