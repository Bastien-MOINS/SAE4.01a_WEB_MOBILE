## Nolan Morain
## Bastien Moins
## Nicolas Camera
# SAE4.01a_WEB_MOBILE

## 1. Architecture du Projet

Afin d'assurer la maintenabilité et la clarté du code, nous avons adopté une structure où chaque composant de la SAE est isolé dans un répertoire dédié :

### Aperçu de l'arborescence

```text
.
├── App_Mobile/
│   ├── lib/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── screens/
│   └── test/
├── REST/
│   ├── instance/
│   └── vols/ 
├── SPA/
│   ├── api/
│   ├── components/
│   ├── functional/ 
│   └── views/
└── SQL/
```

* **`App_Mobile/`** : Développement de l'application mobile (Flutter).
* **`SPA/`** : Développement de l'interface Web (Single Page Application).
* **`REST/`** : Code source du Back-end (API Flask).
* **`SQL/`** : Scripts de création, schémas de la base de données et les requêtes.

### Application Mobile
Le répertoire `App_Mobile/` suit une structure pour séparer la logique métier de l'interface utilisateur :
* **`test/`** : Contient l'ensemble des tests unitaires et fonctionnels.
* **`lib/`** : Cœur de l'application, divisé en trois piliers :
    * **`models/`** : Définition des classes de données, modèles d'objets et API.
    * **`repositories/`** : Gestion du stockage local (via les SharedPreferences).
    * **`screens/`** : Ensemble des fichiers de vues et composants de l'interface utilisateur (UI).

### Interface Web(SPA)
L'architecture suit une structure spécifique pour faciliter la maintenance :
* **`api/`** : Services de communication avec le backend Flask.
* **`components/`** : Éléments d'interface utilisateur réutilisables.
* **`functional/`** : Logique métier, utilitaires et fonctions de traitement.
* **`views/`** : Pages principales et gestion des routes.

### Backend API
On a choisi d'isoler le serveur flask pour ne pas tout mélanger, avec une structure : 
* **`instance/`** : Stockage de la base de données SQLite.
* **`vols/`** : Logique métier, gestion des routes API(views.py) et modèles de données(models.py).

Ce guide détaille les étapes nécessaires pour configurer l'environnement local, installer les dépendances et lancer les applications.

## 2. Prérequis Système

Avant de commencer, assurez-vous d'avoir installé :
- Python 3
- Flutter SDK ([Guide d'installation officiel](https://docs.flutter.dev/install))
- Un navigateur web (Google Chrome recommandé)

## 3. Configuration du Backend (Flask)

Le backend se situe dans le répertoire `REST/`. Suivez ces étapes pour l'initialiser :

### Création et activation de l'environnement virtuel
Ouvrez un terminal dans le répertoire racine du projet et exécutez :

```bash
virtualenv -p python3 venv

source venv/bin/activate
```

### Installation des dépendances Python

```bash
pip install -r requirements.txt
```

### Initialisation de la base de données et lancement

```bash
flask syncdb

flask run
```

## 4. Configuration du Frontend (Application utilisateur - Flutter)

Le frontend (Flutter) se situe dans le répertoire `App_Mobile/`. Suivez ces étapes pour l'initialiser :

### Installation des dépendances Flutter

```bash
flutter pub get
```

### Lancement de l'application

```bash
flutter run -d chrome
```

## 5. Configuration du Frontend (Application administrateur  - SPA)

Le frontend (SPA) se situe dans le répertoire `SPA/`. Suivez ces étapes pour l'initialiser :

### démarrer le serveur HTTP

```bash
python -m http.server
```

### Lancement de l'application

aller sur votre navigateur à l'adresse : http://localhost:8000/