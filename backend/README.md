# Order Service - Spring Boot Backend

Service REST complet de gestion de commandes avec Spring Boot 3.2 et PostgreSQL (Supabase).

## Fonctionnalités

- Créer, lire, mettre à jour et supprimer des commandes
- Gestion des statuts (PENDING, CONFIRMED, PROCESSING, SHIPPED, DELIVERED, CANCELLED)
- Suivi des informations client et produit
- Calcul automatique du montant total
- API RESTful avec support CORS
- Intégration base de données avec JPA/Hibernate
- Validation des données

## Prérequis

- Java 17 ou supérieur
- Maven 3.6+
- Base de données PostgreSQL (Supabase)

## Configuration

Mettez à jour le fichier `../.env` avec vos credentials Supabase:

```env
DATABASE_URL=postgresql://postgres:votre_password@db.ygxoxqmagowztruehtgi.supabase.co:5432/postgres
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=votre_password
```

## Démarrage

### Option 1: Maven

```bash
mvn clean install
mvn spring-boot:run
```

### Option 2: JAR

```bash
mvn clean package
java -jar target/order-service-1.0.0.jar
```

L'application démarre sur `http://localhost:8080`

## Endpoints API

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/api/orders/health` | Vérifier l'état |
| GET | `/api/orders` | Toutes les commandes |
| GET | `/api/orders/{id}` | Commande par ID |
| GET | `/api/orders/customer/{email}` | Commandes par email |
| GET | `/api/orders/status/{status}` | Commandes par statut |
| POST | `/api/orders` | Créer commande |
| PATCH | `/api/orders/{id}/status` | Modifier statut |
| DELETE | `/api/orders/{id}` | Supprimer commande |

## Exemple de requête

```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Jean Dupont",
    "customerEmail": "jean@example.com",
    "productName": "Ordinateur Portable",
    "quantity": 1,
    "price": 999.99
  }'
```

## Tests

```bash
mvn test
```

## Structure du projet

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/example/orderservice/
│   │   │   ├── OrderServiceApplication.java
│   │   │   ├── controller/
│   │   │   ├── service/
│   │   │   ├── repository/
│   │   │   ├── model/
│   │   │   ├── dto/
│   │   │   ├── config/
│   │   │   └── exception/
│   │   └── resources/
│   │       └── application.properties
│   └── test/
└── pom.xml
```
