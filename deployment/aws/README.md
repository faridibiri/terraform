# AWS Deployment Scripts

Scripts PowerShell pour déployer l'application sur AWS EKS.

## Prérequis

- AWS CLI configuré avec credentials valides
- Docker installé
- kubectl installé
- Terraform appliqué (infrastructure créée)

## Scripts disponibles

### 1. ecr-push.ps1
Construit et pousse l'image Docker vers AWS ECR.

```powershell
./ecr-push.ps1 -Region us-east-1 -Repository order-service -Tag latest
```

**Paramètres:**
- `Region`: Région AWS (défaut: us-east-1)
- `Repository`: Nom du repository ECR (défaut: order-service)
- `Tag`: Tag de l'image (défaut: latest)

### 2. eks-config.ps1
Configure kubectl pour accéder au cluster EKS.

```powershell
./eks-config.ps1 -ClusterName order-service-cluster -Region us-east-1
```

**Paramètres:**
- `ClusterName`: Nom du cluster EKS
- `Region`: Région AWS

### 3. deploy-to-eks.ps1
Déploie l'application complète sur EKS (combine les étapes précédentes).

```powershell
./deploy-to-eks.ps1 -Region us-east-1 -ClusterName order-service-cluster
```

**Paramètres:**
- `Region`: Région AWS
- `ClusterName`: Nom du cluster EKS
- `Repository`: Nom du repository ECR
- `Tag`: Tag de l'image

## Flux de déploiement complet

1. **Créer l'infrastructure avec Terraform:**
   ```powershell
   cd ../terraform
   ./deploy.ps1 init
   ./deploy.ps1 plan
   ./deploy.ps1 apply
   ```

2. **Pousser l'image vers ECR:**
   ```powershell
   cd ../aws
   ./ecr-push.ps1
   ```

3. **Déployer sur EKS:**
   ```powershell
   ./deploy-to-eks.ps1
   ```

## Vérification

Vérifier le déploiement:
```bash
kubectl get all -n order-service
kubectl get service order-service -n order-service
```

Voir les logs:
```bash
kubectl logs -n order-service -l app=order-service -f
```

## Nettoyage

Pour supprimer les ressources:
```powershell
cd ../kubernetes
./deploy.ps1 delete

cd ../terraform
./deploy.ps1 destroy
```
