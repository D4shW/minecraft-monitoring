# Installation et Configuration d'un Serveur FTP (vsftpd) sur Ubuntu

## 1. Installation de vsftpd
```
sudo apt update
sudo apt install vsftpd -y
```

2. Sauvegarde de la configuration actuelle
```
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.backup
```
3. Configuration de vsftpd

Modifier le fichier de configuration :

sudo nano /etc/vsftpd.conf

Ajoutez ou modifiez ces lignes :
```
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
user_sub_token=$USER
local_root=/home/$USER/ftp
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
```
Sauvegarder avec CTRL+X, Y et Entrée.
4. Création du dossier FTP sécurisé
```
mkdir -p ~/ftp/upload
chmod 550 ~/ftp
chmod 750 ~/ftp/upload
```
5. Redémarrage et activation du service
```
sudo systemctl restart vsftpd
sudo systemctl enable vsftpd
```
6. Ouverture des ports dans le pare-feu (si UFW est activé)
```
sudo ufw allow 20:21/tcp
sudo ufw allow 40000:50000/tcp
sudo ufw reload
```
7. Test de connexion FTP
```
ftp localhost
```
