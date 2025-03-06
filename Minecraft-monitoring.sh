touch mincraft-autoinstall.sh

nano minecraft-autoinstall.sh

!/bin/bash

# Définition des variables
MC_VERSION="1.19.2"
MC_SERVER_JAR="server.jar"
MC_URL="https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar"
MEMORY_MIN="1G"
MEMORY_MAX="2G"

# Création du dossier du serveur
mkdir -p minecraft-server
cd minecraft-server || exit

# Téléchargement du serveur si absent
if [ ! -f "$MC_SERVER_JAR" ]; then
    echo "Téléchargement de Minecraft Server $MC_VERSION..."
    curl -o "$MC_SERVER_JAR" "$MC_URL"
fi

# Accepter l'EULA automatiquement
echo "eula=true" > eula.txt

# Boucle pour relancer le serveur après un arrêt
while true; do
    echo "Lancement du serveur Minecraft..."
    java -Xms$MEMORY_MIN -Xmx$MEMORY_MAX -jar "$MC_SERVER_JAR" nogui
    echo "Le serveur s'est arrêté. Redémarrage dans 10 secondes..."
    sleep 10
done

./minecraft-autoinstall.sh