# Deployment Guide - Order Service

Guide complet de déploiement avec séparation claire entre Docker, Kubernetes, Terraform et AWS.

## Structure du Projet

```
deployment/
├── docker/              # Configuration Docker locale
│   ├── docker-compose.yml
│   ├── build.ps1
│   └── run.ps1
│
├── kubernetes/          # Manifests Kubernetes
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── deploy.ps1
│
├── terraform/           # Infrastructure as Code (AWS)
│   ├── main.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── ecr.tf
│   ├── eks.tf
│   ├── outputs.tf
│   └── deploy.ps1
│
└── aws/                 # Scripts de déploiement AWS
    ├── ecr-push.ps1
    ├── eks-config.ps1
    └── deploy-to-eks.ps1
```

## Déploiement Local avec Docker

### Prérequis
- Docker Desktop installé
- Docker Compose installé

### Commandes

**Build l'image:**
```powershell
cd deployment/docker
./build.ps1
```

**Démarrer les services:**
```powershell
./run.ps1 up
```

**Arrêter les services:**
```powershell
./run.ps1 down
```

**Voir les logs:**
```powershell
./run.ps1 logs
```

L'application sera accessible sur `http://localhost:8080`

## Déploiement Kubernetes (Local/On-Premise)

### Prérequis
- kubectl installé
- Cluster Kubernetes accessible (Minikube, Docker Desktop, etc.)

### Commandes

**Déployer l'application:**
```powershell
cd deployment/kubernetes
./deploy.ps1 apply
```

**Vérifier le statut:**
```powershell
./deploy.ps1 status
```

**Voir les logs:**
```powershell
./deploy.ps1 logs
```

**Port forwarding (accès local):**
```powershell
./deploy.ps1 port-forward
```

**Supprimer les ressources:**
```powershell
./deploy.ps1 delete
```

## Déploiement AWS avec Terraform

### Prérequis
- AWS CLI configuré
- Terraform installé
- Credentials AWS valides

### Infrastructure créée
- VPC avec sous-réseaux publics et privés
- NAT Gateways
- Cluster EKS
- Node Group EKS
- ECR Repository

### Commandes

**Initialiser Terraform:**
```powershell
cd deployment/terraform
./deploy.ps1 init
```

**Voir les changements:**
```powershell
./deploy.ps1 plan
```

**Appliquer l'infrastructure:**
```powershell
./deploy.ps1 apply
```

**Voir les outputs:**
```powershell
./deploy.ps1 output
```

**Détruire l'infrastructure:**
```powershell
./deploy.ps1 destroy
```

## Déploiement sur AWS EKS

### Prérequis
- Infrastructure Terraform déployée
- AWS CLI configuré
- kubectl installé
- Docker installé

### Étapes

**1. Pousser l'image vers ECR:**
```powershell
cd deployment/aws
./ecr-push.ps1 -Region us-east-1 -Repository order-service -Tag latest
```

**2. Configurer kubectl pour EKS:**
```powershell
./eks-config.ps1 -ClusterName order-service-cluster -Region us-east-1
```

**3. Déployer sur EKS:**
```powershell
./deploy-to-eks.ps1
```

## Script de Déploiement Principal

Un script interactif unifié est disponible à la racine du projet:

```powershell
./deploy.ps1
```

Ce script offre un menu pour:
1. Déploiement Docker local
2. Déploiement Kubernetes
3. Provisionnement Terraform
4. Déploiement AWS
5. Déploiement Full Stack (tout en une fois)

## Déploiement Full Stack

Pour déployer l'infrastructure complète sur AWS:

```powershell
./deploy.ps1
# Sélectionner option 5: Full Stack
```

Cela va:
1. Créer l'infrastructure AWS avec Terraform
2. Builder et pousser l'image Docker vers ECR
3. Déployer l'application sur EKS

## Variables d'Environnement

Assurez-vous de configurer les variables dans:
- `.env` pour Docker local
- `deployment/kubernetes/secret.yaml` pour Kubernetes
- `deployment/terraform/variables.tf` pour Terraform

## Monitoring et Logs

**Docker:**
```bash
docker-compose logs -f
```

**Kubernetes:**
```bash
kubectl logs -n order-service -l app=order-service -f
```

**AWS EKS:**
```bash
kubectl logs -n order-service -l app=order-service -f
```

## Rollback

**Kubernetes:**
```bash
kubectl rollout undo deployment/order-service -n order-service
```

**EKS:**
```bash
kubectl rollout undo deployment/order-service -n order-service
```

## Nettoyage

**Docker:**
```powershell
cd deployment/docker
./run.ps1 down
```

**Kubernetes:**
```powershell
cd deployment/kubernetes
./deploy.ps1 delete
```

**AWS (tout supprimer):**
```powershell
cd deployment/kubernetes
./deploy.ps1 delete

cd ../terraform
./deploy.ps1 destroy
```

## Troubleshooting

### Docker
- Vérifier que Docker Desktop est démarré
- Vérifier le fichier `.env`

### Kubernetes
- Vérifier que le cluster est accessible: `kubectl cluster-info`
- Vérifier les credentials dans `secret.yaml`

### AWS
- Vérifier AWS CLI: `aws sts get-caller-identity`
- Vérifier les permissions IAM
- Vérifier les quotas AWS

## Support

Pour des instructions détaillées, consultez les README dans chaque sous-dossier:
- `deployment/docker/`
- `deployment/kubernetes/`
- `deployment/terraform/`
- `deployment/aws/`
