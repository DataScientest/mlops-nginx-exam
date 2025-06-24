# Examen Nginx pour MLOps 🚀

### Cas d'Usage et Modèle Fourni

Pour cet examen, vous travaillerez avec un modèle de reconnaissance de sentiments d'une phrase donnée.

- **Modèle** : Un modèle model.joblib pré-entraîné.

- **API** : Une API FastAPI simple (similaire à celle du cours) qui prend une phrase en entrée et retourne le prédit.

### Fichiers Fournis** :

```
mlops-nginx-exam/
├── app/
│   ├── model.joblib     # Modèle pré-entraîné
│   └── requirements.txt # Dépendances Python de l'API
├── nginx/
│   ├── nginx.conf       # Votre configuration Nginx à compléter
│   ├── certs/           # Pour vos certificats SSL
│   └── .htpasswd        # Pour l'authentification basique
├── docker-compose.yml   # Votre fichier Docker Compose à compléter
├── Makefile             # Votre Makefile à compléter
└── README.md
```

### Objectif du Projet

Mettre en place une architecture conteneurisée utilisant Nginx comme point d'entrée unique pour une API de modèle ML, en implémentant les fonctionnalités suivantes :

1.  **Reverse Proxy** : Nginx doit router le trafic vers l'API du modèle.

2.  **Équilibrage de Charge** : L'API du modèle doit être déployée en plusieurs instances (au moins 3), et Nginx doit répartir le trafic entre elles.

3.  **HTTPS (SSL/TLS)** : Toutes les communications vers Nginx doivent être sécurisées via HTTPS, en utilisant des certificats auto-signés. Le trafic HTTP doit être redirigé vers HTTPS.

1. **Préparation du Projet** : 
    - Clonez ce dépôt Git.
    
2. **Lancez tous les services** : `make start-project`.
    - Vous pouvez accèder aux interfaces :
        - Prometheus UI : `http://localhost:9090`
        - Grafana UI : `http://localhost:3000` (admin:admin)

3. **Tester le projet** :
    - Vous pouvez effectuer un test par défaut avec `make test-api`.

4. **Test du Routage A/B Testing** :
    - l'entête `X-Experiment-Group: debug` vous fait utiliser le service B (`api-v2`).
    - Vous pouvez effectuer un test par défaut avec `make test-api-debug`.
    - Vérifier la réponse, elle devrait contenir plus d'informations à propos de la prédiction du modèle.

    - Vous devrez déployer deux versions de l'API de modèle (par exemple, `api-v1` et `api-v2`). Ces versions peuvent être simulées en modifiant légèrement la réponse de l'API (ex: ajouter un champ "version": "v1" ou "version": "v2" dans la réponse JSON).

    - Nginx doit router le trafic vers la version v2 de l'API si la requête contient un en-tête HTTP spécifique (par exemple, `X-Experiment-Group: debug`).

- Vous pouvez générer un nouveau `model.joblib` avec le fichier `src/gen_model.py`.
- On pourrait également tester la charge et le rate limiting sur l'API principale avec la commande suivante :
```bash
for i in {1..100}; do curl -s -o /dev/null -w "%{http_code}\n" -X POST "https://localhost/predict" -H "Content-Type: application/json" -d '{"sentence": "Oh yeah, that was soooo cool!"}' --user "admin:admin" --cacert ./deployments/nginx/certs/nginx.crt; done
```
