# Examen Nginx pour MLOps 🚀

### Cas d'Usage et Modèle Fourni

Pour cet examen, vous travaillerez avec un modèle de reconnaissance de sentiments d'une phrase donnée.

- **Modèle** : Un modèle model.joblib pré-entraîné.

- **API** : Une API FastAPI simple (similaire à celle du cours) qui prend une phrase en entrée et retourne le prédit.

### Fichiers Fournis :

```
mlops-nginx-exam/
├── deployments
│   ├── nginx/
│   │   ├── certs/              # Pour vos certificats SSL
│   │   ├── .htpasswd           # Pour l'authentification basique
│   │   ├── Dockerfile          # Le Dockerfile nginx à compléter
│   │   └── nginx.conf          # Votre configuration Nginx à compléter
│   ├── prometheus/
│   │   └── prometheus.yml      # Le fichier de configuration Prometheus
├── src
│   ├── api/
│   │   ├── model.joblib        # Modèle ML pré-entraîné
│   │   └── requirements.txt    # Dépendances Python de l'API
├── docker-compose.yml          # Votre fichier Docker Compose à compléter
├── Makefile                    # Votre Makefile à compléter
└── README.md                   # Ce fichier
```

### Objectif du Projet

Mettre en place une architecture conteneurisée utilisant Nginx comme point d'entrée unique pour une API de modèle ML, en implémentant les fonctionnalités suivantes :

1.  **Reverse Proxy** : Nginx doit router le trafic vers l'API du modèle.

2.  **Équilibrage de Charge** : L'API du modèle doit être déployée en plusieurs instances (au moins 3), et Nginx doit répartir le trafic entre elles.

3.  **HTTPS (SSL/TLS)** : Toutes les communications vers Nginx doivent être sécurisées via HTTPS, en utilisant des certificats auto-signés. Le trafic HTTP doit être redirigé vers HTTPS.

4.  **Authentification Basique** : L'accès à l'endpoint de prédiction (`/predict`) doit être protégé par une authentification basique (`username/password`).

5.  **Rate Limiting** : L'endpoint de prédiction (`/predict`) doit être protégé par une limitation de débit (par exemple, 10 requêtes par seconde par adresse IP).

6.  **A/B Testing** :

    - Vous devrez déployer deux versions de l'API de modèle (par exemple, `api-v1` et `api-v2`). Ces versions peuvent être simulées en modifiant légèrement la réponse de l'API (ex: ajouter un champ "version": "v1" ou "version": "v2" dans la réponse JSON).

    - Nginx doit router le trafic vers la version v2 de l'API si la requête contient un en-tête HTTP spécifique (par exemple, `X-Experiment-Group: debug`).

    - Si cet en-tête n'est pas présent, le trafic doit être routé vers la version v1 par défaut.

### Livrables

Un dépôt Git contenant :

- Tous les Dockerfiles nécessaires.

- Le fichier docker-compose.yml configuré pour orchestrer tous les services (Nginx, API v1, API v2, etc.).

- Le fichier `nginx.conf` avec toutes les configurations requises (reverse proxy, SSL, équilibrage de charge, authentification, limitation de débit, et le routage A/B).

- Les scripts ou fichiers auxiliaires (ex: nginx/certs/, nginx/.htpasswd).

- Le code de l'API (`src/api/main.py`, `src/api/requirements.txt`, `src/api/model.joblib`).

### Évaluation

Votre projet sera évalué sur :

- La conformité de l'architecture aux exigences (tous les services sont conteneurisés et orchestrés).

- Le bon fonctionnement de chaque fonctionnalité :

    - Accès à l'API via Nginx.

    - Équilibrage de charge visible (par exemple, en observant les logs des instances API).

    - Accès HTTPS fonctionnel avec certificat auto-signé.

    - Authentification basique fonctionnelle.

    - Limitation de débit qui rejette les requêtes excessives.

    - Le routage A/B testing fonctionne comme spécifié (le trafic est bien redirigé vers la bonne version de l'API en fonction de l'en-tête `X-Experiment-Group`).

    - La clarté de votre configuration Nginx et Docker Compose.
