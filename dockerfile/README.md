# Dolibarr Docker Setup

Configuration Docker pour faire tourner Dolibarr 7.0 en local avec PHP 7.2.

## Structure

```
dockerfile/
├── docker-compose.yml    # Configuration des services
├── Dockerfile            # Image PHP 7.4 avec Apache
├── init.sh               # Script d'initialisation
├── init-db/              # Scripts SQL d'initialisation
│   └── 01-init.sql       # Dump de la base de données (nettoyé)
├── .env                  # Variables d'environnement
├── .env.example          # Exemple de configuration
├── .gitignore
└── README.md
```

## Prérequis

- Docker
- Docker Compose

## Installation

1. **Initialiser le projet** :
   ```bash
   cd dockerfile
   ./init.sh
   ```

2. **Modifier les mots de passe** dans le fichier `.env` :
   ```
   MYSQL_ROOT_PASSWORD=votre_mot_de_passe_root
   MYSQL_DATABASE=dolibarr
   MYSQL_USER=dolibarr
   MYSQL_PASSWORD=votre_mot_de_passe
   ```

3. **Mettre à jour conf.php** si nécessaire :
   Le fichier `conf.php` a déjà été configuré avec les paramètres suivants :
   ```php
   $dolibarr_main_document_root='/var/www/html';
   $dolibarr_main_data_root='/var/www/html/documents';
   $dolibarr_main_db_host='db';
   $dolibarr_main_db_name='dolibarr';
   $dolibarr_main_db_user='dolibarr';
   $dolibarr_main_db_pass='dolibarr_password_a_changer';
   ```
   Assurez-vous que le mot de passe correspond à celui du fichier `.env`.

4. **Démarrer les conteneurs** :
   ```bash
   docker-compose up -d
   ```

## Accès

- **Dolibarr** : http://localhost:8080
- **phpMyAdmin** : http://localhost:8081

## Configuration des chemins

### Dans le conteneur Docker

| Paramètre | Chemin |
|-----------|--------|
| Document root | `/var/www/html` |
| Documents Dolibarr | `/var/www/html/documents` |
| Host BDD | `db` |

### Volumes persistants (sur l'hôte)

Les données sont stockées en dehors des conteneurs :
- **Code source** : `../dolibarr2021.agoralogie.fr/public_html` -> `/var/www/html`
- **Documents** : `/home/agoralogie/Nextcloud/Documents/Administration_agoralogie/dolibarr21/documents`
- **MySQL** : `/home/agoralogie/Nextcloud/Documents/Administration_agoralogie/dolibarr21/mysql_data`

## Commandes utiles

```bash
# Démarrer
docker-compose up -d

# Arrêter
docker-compose down

# Voir les logs
docker-compose logs -f

# Reconstruire l'image
docker-compose build --no-cache

# Accéder au conteneur PHP
docker exec -it dolibarr_app bash

# Accéder au conteneur MySQL
docker exec -it dolibarr_db mysql -u dolibarr -p dolibarr
```

## Notes de sécurité

Le dump SQL original contenait du code malveillant qui a été nettoyé :
- Suppression d'entrées malveillantes dans la table `llx_menu` (injection de commandes système)
- Suppression du compte utilisateur `testadmins` créé par l'attaquant

**Recommandations** :
- Changer les mots de passe de tous les utilisateurs Dolibarr
- Ne pas exposer cette instance sur Internet sans mise à jour vers une version récente de Dolibarr
