# Projet d'Examen Nginx pour MLOps 🚀

Ce projet est une implémentation d'une architecture conteneurisée mettant en avant l'utilisation de Nginx pour le déploiement, la sécurisation, l'optimisation et le monitoring d'une API de Machine Learning.

## Aperçu du Projet

Ce projet déploie et intègre plusieurs outils fondamentaux pour la mise en production de modèles ML :

- **API Modèle ML (FastAPI)** : Une API simple pour la prédiction de la classification d'Iris.
- **Docker** : Utilisé pour conteneuriser l'API et Nginx, garantissant isolation et portabilité.
- **Nginx** : Sert de point d'entrée central, de proxy inverse, d'équilibreur de charge, et gère les aspects de sécurité avancés (HTTPS, authentification, limitation de débit) ainsi que les stratégies de déploiement (A/B testing).
- **Prometheus** : Système de monitoring pour la collecte des métriques techniques (notamment celles de Nginx).
- **Grafana** : Outil de visualisation pour créer des dashboards interactifs des métriques collectées.

## Objectifs du Projet

Le projet vise à démontrer l'implémentation des objectifs suivants :

- **Conteneurisation** : L'API et Nginx sont empaquetés dans des conteneurs Docker distincts.
- **Orchestration** : Gestion du démarrage et de l'interaction des conteneurs via Docker Compose.
- **Déploiement avec Proxy Inverse** : Nginx route le trafic vers l'API du modèle.
- **Scalabilité & Équilibrage de Charge** : L'API est déployée en plusieurs instances, et Nginx répartit le trafic entre elles.
- **Sécurité (HTTPS)** : Les communications vers Nginx sont sécurisées via HTTPS avec des certificats auto-signés.
- **Contrôle d'Accès** : L'accès à l'API est protégé par une authentification basique via Nginx.
- **Limitation de Débit (Rate Limiting)** : L'API est protégée contre les surcharges par Nginx.
- **A/B Testing** : Mise en place d'un routage conditionnel du trafic vers différentes versions de l'API basé sur un en-tête HTTP.
- **Monitoring** : Collecte des métriques de Nginx avec Prometheus et visualisation dans Grafana.

## Architecture Implémentée

Le projet suit une architecture microservices où Nginx est le point d'entrée central gérant l'accès aux instances de l'API et intégrant le monitoring..

```
├── app/
│   ├── v1/
│   │   ├── Dockerfile     # Dockerfile de l'API v1
│   │   └── main.py        # Code de l'API v1 FastAPI
│   ├── v2/
│   │   ├── Dockerfile     # Dockerfile de l'API v2
│   │   └── main.py        # Code de l'API v2 FastAPI
│   ├── model.joblib       # Modèle ML pré-entraîné
│   └── requirements.txt   # Dépendances Python de l'API
├── nginx/
│   ├── Dockerfile         # Dockerfile pour Nginx
│   ├── nginx.conf         # Configuration Nginx
│   ├── certs/             # Certificats SSL auto-signés
│   │   ├── nginx.crt
│   │   └── nginx.key
│   └── .htpasswd          # Fichier d'authentification basique
├── prometheus/
│   └── prometheus.yml     # Configuration Prometheus
├── src/
│   ├── gen_model.py       # Script pour générer model.joblib localement
│   └── tweet_emotions.csv # Dataset pour le model
├── docker-compose.yml     # Orchestration des services
├── Makefile               # Automatisation des tâches
└── README.md              # Ce fichier
```

## Services Docker Compose

Le fichier `docker-compose.yml` orchestre les services suivants :

- `api-v1` : Les instances de la version 1 de l'API de modèle (par défaut). `api-v1` est configuré avec 3 répliques pour l'équilibrage de charge.
- `api-v2` : L'instance de la version 2 (debug) de l'API (pour l'A/B testing).
- `nginx` : Le proxy inverse Nginx, point d'entrée principal.
- `nginx_exporter` : Collecte les métriques de Nginx pour Prometheus.
- `prometheus` : Le serveur Prometheus pour la collecte et le stockage des métriques.- `grafana` : L'interface de visualisation pour les dashboards de monitoring.

## Instructions d'Utilisation

Suivez ces étapes pour lancer et tester l'écosystème MLOps.

1. **Préparation du Projet** : 
    - Clonez ce dépôt Git.
    - **Préparez les images** : 
        Construisez les images Docker avec `make build-project`.
    
2. **Lancez tous les services** : `make run-project`.
    - Vous pouvez accèder aux interfaces :
        - Prometheus UI : `http://localhost:9090`
        - Grafana UI : `http://localhost:3000` (admin:admin)

3. **Tester le projet** :
    - Vous pouvez effectuer un test par défaut avec `make test-api`.
    - Utilisez la commande suivante pour faire des tests avec des entrées plus personalisées : 
    ```bash
    curl -X POST "https://localhost/predict" \
    -H "Content-Type: application/json" \
    -d '{"sentence": "Oh yeah, that was soooo cool!"}' \
    --user admin:admin \
    --insecure
    ```

4. **Test du Routage A/B Testing** :
    - l'entête `X-Experiment-Group: debug` vous fait utiliser le service B (`api-v2`).
    - Vous pouvez effectuer un test par défaut avec `make test-api-debug`.
    - Utilisez la commande suivante pour faire des tests avec des entrées plus personalisées : 
    ```bash
    curl -X POST "https://localhost/predict" \
    -H "Content-Type: application/json" \
    -H "X-Experiment-Group: debug" \
    -d '{"sentence": "Oh yeah, that was soooo cool!"}' \
    --user admin:admin \
    --insecure
    ```
    - Vérifier la réponse, elle devrait contenir plus d'informations à propos de la prédiction du modèle.

5.  **Arrêter** :
    - Arrêtez les conteneurs avec `make stop-project`

## Extra

- Vous pouvez générer un nouveau `model.joblib` avec le fichier `src/gen_model.py`.
- On pourrait également tester la charge et le rate limiting sur l'API principale avec la commande suivante :
```bash
for i in {1..100}; do curl -s -o /dev/null -w "%{http_code}\n" -X POST "https://localhost/predict" -H "Content-Type: application/json" -d '{"sentence": "Oh yeah, that was soooo cool!"}' --user "admin:admin" --insecure; done
```