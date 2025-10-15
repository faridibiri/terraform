# Guide d'Installation pour Windows

Ce guide décrit comment installer tous les outils nécessaires pour déployer l'application Spring Boot sur AWS EKS avec Terraform sur **Windows**.

## Table des Matières

1. [Prérequis Windows](#prérequis-windows)
2. [Installation de Chocolatey](#installation-de-chocolatey)
3. [Installation des Outils](#installation-des-outils)
4. [Configuration AWS](#configuration-aws)
5. [Vérification de l'Installation](#vérification-de-linstallation)
6. [Prochaines Étapes](#prochaines-étapes)

---

## Prérequis Windows

- Windows 10 ou Windows 11 (64-bit)
- PowerShell 5.1 ou supérieur
- Droits d'administrateur sur votre machine
- Au moins 8 GB de RAM
- 50 GB d'espace disque libre
- Connexion internet stable

---

## Installation de Chocolatey

Chocolatey est un gestionnaire de packages pour Windows qui simplifie l'installation des outils.

### Étapes d'Installation

1. **Ouvrir PowerShell en tant qu'Administrateur**
   - Clic droit sur le menu Démarrer
   - Sélectionnez "Windows PowerShell (Admin)" ou "Terminal (Admin)"

2. **Vérifier la politique d'exécution**
   ```powershell
   Get-ExecutionPolicy
   ```

3. **Installer Chocolatey**
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

4. **Vérifier l'installation**
   ```powershell
   choco --version
   ```

   Vous devriez voir la version de Chocolatey s'afficher (ex: 2.2.2).

---

## Installation des Outils

### 1. AWS CLI

L'AWS CLI permet d'interagir avec les services AWS depuis la ligne de commande.

**Méthode 1 : Avec Chocolatey (Recommandé)**
```powershell
choco install awscli -y
```

**Méthode 2 : Installeur MSI**
1. Téléchargez : [AWS CLI MSI](https://awscli.amazonaws.com/AWSCLIV2.msi)
2. Exécutez le fichier MSI
3. Suivez l'assistant d'installation

**Vérifier l'installation**
```powershell
# Fermez et rouvrez PowerShell
aws --version
```

Résultat attendu : `aws-cli/2.x.x Python/3.x.x Windows/...`

---

### 2. Terraform

Terraform permet de gérer l'infrastructure AWS comme du code.

**Installation avec Chocolatey**
```powershell
choco install terraform -y
```

**Vérifier l'installation**
```powershell
terraform --version
```

Résultat attendu : `Terraform v1.6.x`

---

### 3. kubectl

kubectl est l'outil en ligne de commande pour Kubernetes.

**Installation avec Chocolatey**
```powershell
choco install kubernetes-cli -y
```

**Vérifier l'installation**
```powershell
kubectl version --client
```

---

### 4. eksctl

eksctl simplifie la création et la gestion de clusters EKS.

**Installation avec Chocolatey**
```powershell
choco install eksctl -y
```

**Vérifier l'installation**
```powershell
eksctl version
```

---

### 5. Docker Desktop

Docker est nécessaire pour construire et exécuter des conteneurs.

**Installation**

1. Téléchargez [Docker Desktop pour Windows](https://www.docker.com/products/docker-desktop/)
2. Exécutez l'installeur `Docker Desktop Installer.exe`
3. Suivez l'assistant d'installation
4. **Redémarrez votre ordinateur** (obligatoire)
5. Démarrez Docker Desktop depuis le menu Démarrer
6. Attendez que Docker démarre complètement (icône Docker dans la barre des tâches)

**Configuration WSL 2 (si demandé)**

Si Docker demande WSL 2 :
1. Ouvrez PowerShell en administrateur
2. Exécutez :
   ```powershell
   wsl --install
   ```
3. Redémarrez votre ordinateur
4. Relancez Docker Desktop

**Vérifier l'installation**
```powershell
docker --version
docker run hello-world
```

Si `hello-world` s'exécute correctement, Docker est bien installé !

---

### 6. Java JDK 17

Java est nécessaire pour compiler l'application Spring Boot.

**Installation avec Chocolatey**
```powershell
choco install openjdk17 -y
```

**Vérifier l'installation**
```powershell
java -version
javac -version
```

Résultat attendu : `openjdk version "17.x.x"`

---

### 7. Maven

Maven est l'outil de build pour les projets Java.

**Installation avec Chocolatey**
```powershell
choco install maven -y
```

**Vérifier l'installation**
```powershell
mvn --version
```

Résultat attendu :
```
Apache Maven 3.x.x
Maven home: C:\ProgramData\chocolatey\lib\maven\apache-maven-3.x.x
Java version: 17.x.x
```

---

### 8. Git

Git est nécessaire pour la gestion de version.

**Installation avec Chocolatey**
```powershell
choco install git -y
```

**Vérifier l'installation**
```powershell
git --version
```

---

### 9. Un Éditeur de Code (Optionnel mais Recommandé)

**Visual Studio Code**
```powershell
choco install vscode -y
```

**IntelliJ IDEA Community**
```powershell
choco install intellijidea-community -y
```

---

## Configuration AWS

### Étape 1 : Créer un Utilisateur IAM

1. Connectez-vous à la [Console AWS](https://console.aws.amazon.com/)
2. Accédez à **IAM** (Identity and Access Management)
3. Dans le menu de gauche, cliquez sur **Users** → **Add users**
4. Créez un utilisateur avec les paramètres suivants :
   - Nom d'utilisateur : `terraform-user`
   - Type d'accès : Cochez **"Programmatic access"** (accès programmatique)
5. Cliquez sur **Next: Permissions**
6. Attachez les politiques suivantes :
   - `AmazonEKSClusterPolicy`
   - `AmazonEKSWorkerNodePolicy`
   - `AmazonEC2ContainerRegistryFullAccess`
   - `AmazonVPCFullAccess`
   - `AmazonRDSFullAccess`
   - `IAMFullAccess`
   - `AmazonEC2FullAccess`
7. Cliquez sur **Next** puis **Create user**
8. **IMPORTANT** : Téléchargez le fichier CSV contenant :
   - Access Key ID
   - Secret Access Key

   ⚠️ Conservez ces informations en sécurité, vous ne pourrez plus les récupérer !

### Étape 2 : Configurer AWS CLI

Ouvrez PowerShell et exécutez :

```powershell
aws configure
```

Entrez les informations suivantes :

```
AWS Access Key ID [None]: VOTRE_ACCESS_KEY_ID
AWS Secret Access Key [None]: VOTRE_SECRET_ACCESS_KEY
Default region name [None]: eu-west-1
Default output format [None]: json
```

**Régions AWS recommandées** :
- Europe (Irlande) : `eu-west-1`
- Europe (Paris) : `eu-west-3`
- US East (Virginie) : `us-east-1`

### Étape 3 : Vérifier la Configuration

```powershell
aws sts get-caller-identity
```

Résultat attendu :
```json
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-user"
}
```

Si vous voyez ces informations, la configuration est réussie ! ✅

---

## Vérification de l'Installation

Créez un fichier PowerShell pour vérifier toutes les installations :

**check-install.ps1**
```powershell
# Script de vérification des installations
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Vérification des installations" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$tools = @(
    @{Name="AWS CLI"; Command="aws --version"},
    @{Name="Terraform"; Command="terraform --version"},
    @{Name="kubectl"; Command="kubectl version --client --short"},
    @{Name="eksctl"; Command="eksctl version"},
    @{Name="Docker"; Command="docker --version"},
    @{Name="Java"; Command="java -version"},
    @{Name="Maven"; Command="mvn --version"},
    @{Name="Git"; Command="git --version"}
)

foreach ($tool in $tools) {
    Write-Host "Vérification de $($tool.Name)..." -ForegroundColor Yellow
    try {
        $result = Invoke-Expression $tool.Command 2>&1
        Write-Host "✓ $($tool.Name) est installé" -ForegroundColor Green
        Write-Host "  $($result[0])" -ForegroundColor Gray
    }
    catch {
        Write-Host "✗ $($tool.Name) n'est PAS installé" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Vérification terminée!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
```

**Exécuter le script**
```powershell
powershell -ExecutionPolicy Bypass -File check-install.ps1
```

---

## Configuration de l'Environnement Windows

### Variables d'Environnement

Vérifiez que les variables suivantes sont bien configurées :

```powershell
# Voir toutes les variables d'environnement
Get-ChildItem Env:

# Vérifier JAVA_HOME
echo $env:JAVA_HOME

# Vérifier PATH
echo $env:PATH
```

Si `JAVA_HOME` n'est pas défini, configurez-le :

```powershell
# Trouver le chemin Java
where.exe java

# Définir JAVA_HOME (remplacez par votre chemin)
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\OpenJDK\jdk-17.x.x', 'Machine')
```

---

## Adaptation des Commandes pour Windows

### Différences Importantes

| Linux/macOS | Windows PowerShell | Description |
|-------------|-------------------|-------------|
| `ls` | `dir` ou `ls` | Lister les fichiers |
| `cat file.txt` | `Get-Content file.txt` | Afficher contenu |
| `export VAR=value` | `$env:VAR="value"` | Définir variable |
| `./script.sh` | `.\script.ps1` | Exécuter script |
| `/path/to/file` | `C:\path\to\file` | Chemins absolus |

### Scripts Bash → PowerShell

Le script `deploy.sh` (Bash) doit être adapté pour Windows. Créez `deploy.ps1` :

**deploy.ps1**
```powershell
# Deployment Script for Windows
$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Deployment Script for Orders Service  " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$AWS_REGION = if ($env:AWS_REGION) { $env:AWS_REGION } else { "eu-west-1" }
$TERRAFORM_DIR = ".\terraform"

if (-not (Test-Path $TERRAFORM_DIR)) {
    Write-Host "Error: Terraform directory not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Step 1: Getting Terraform outputs..." -ForegroundColor Yellow
Push-Location $TERRAFORM_DIR
$ECR_REPO = terraform output -raw ecr_repository_url
$CLUSTER_NAME = terraform output -raw cluster_name
$DB_ENDPOINT = terraform output -raw db_endpoint
$DB_NAME = terraform output -raw db_name
Pop-Location

if (-not $ECR_REPO -or -not $CLUSTER_NAME) {
    Write-Host "Error: Failed to get Terraform outputs!" -ForegroundColor Red
    exit 1
}

Write-Host "ECR Repository: $ECR_REPO" -ForegroundColor Green
Write-Host "EKS Cluster: $CLUSTER_NAME" -ForegroundColor Green
Write-Host ""

Write-Host "Step 2: Building Docker image..." -ForegroundColor Yellow
docker build -t orders-service:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Docker image built successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "Step 3: Tagging Docker image..." -ForegroundColor Yellow
$TIMESTAMP = Get-Date -Format "yyyyMMdd-HHmmss"
docker tag orders-service:latest "${ECR_REPO}:latest"
docker tag orders-service:latest "${ECR_REPO}:${TIMESTAMP}"
Write-Host ""

Write-Host "Step 4: Logging into ECR..." -ForegroundColor Yellow
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: ECR login failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Logged into ECR successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "Step 5: Pushing Docker image to ECR..." -ForegroundColor Yellow
docker push "${ECR_REPO}:latest"
docker push "${ECR_REPO}:${TIMESTAMP}"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker push failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Image pushed successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "Step 6: Updating kubeconfig..." -ForegroundColor Yellow
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to update kubeconfig!" -ForegroundColor Red
    exit 1
}
Write-Host "Kubeconfig updated successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "Step 7: Creating Kubernetes secrets..." -ForegroundColor Yellow
$DB_URL = "jdbc:postgresql://${DB_ENDPOINT}/${DB_NAME}"
kubectl create secret generic db-secrets `
  --from-literal=url="$DB_URL" `
  --from-literal=username="admin" `
  --from-literal=password="ChangeMe123!SecurePassword" `
  --dry-run=client -o yaml | kubectl apply -f -
Write-Host ""

Write-Host "Step 8: Updating deployment manifest..." -ForegroundColor Yellow
(Get-Content .\k8s\deployment.yaml) -replace '<ECR_REPO_URL>', $ECR_REPO | Set-Content .\k8s\deployment-updated.yaml
Write-Host ""

Write-Host "Step 9: Deploying to Kubernetes..." -ForegroundColor Yellow
kubectl apply -f .\k8s\deployment-updated.yaml
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Kubernetes deployment failed!" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "Step 10: Waiting for deployment to be ready..." -ForegroundColor Yellow
kubectl rollout status deployment/orders-service --timeout=5m
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Deployment completed successfully!    " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Getting service information..." -ForegroundColor Yellow
kubectl get service orders-service
Write-Host ""

Write-Host "To get the Load Balancer URL, run:" -ForegroundColor Cyan
Write-Host "kubectl get service orders-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'" -ForegroundColor White
```

---

## Prochaines Étapes

Maintenant que tous les outils sont installés, vous pouvez :

1. **Cloner ou créer le projet** Spring Boot
2. **Configurer Terraform** avec vos paramètres AWS
3. **Déployer l'infrastructure** avec `terraform apply`
4. **Builder et déployer l'application** avec `.\deploy.ps1`

Consultez le fichier README.md principal pour les instructions complètes de déploiement.

---

## Résolution de Problèmes Windows

### Docker ne démarre pas

**Problème** : "Docker Desktop requires Windows 10 Pro/Enterprise/Education"

**Solution** : Activez WSL 2
```powershell
# PowerShell en Administrateur
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --install
```

### Erreur "Execution Policy"

**Problème** : "cannot be loaded because running scripts is disabled"

**Solution** :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### AWS CLI non reconnu après installation

**Problème** : `'aws' is not recognized`

**Solution** : Fermez et rouvrez PowerShell, ou redémarrez votre ordinateur.

### Maven ne trouve pas JAVA_HOME

**Problème** : "JAVA_HOME is not set"

**Solution** :
```powershell
# Trouver Java
where.exe java

# Définir JAVA_HOME (exemple)
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\OpenJDK\jdk-17.0.x', 'Machine')

# Redémarrer PowerShell
```

---

## Ressources Supplémentaires

- [Documentation Chocolatey](https://docs.chocolatey.org/)
- [Docker Desktop WSL 2](https://docs.docker.com/desktop/windows/wsl/)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
- [AWS CLI sur Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html)

---

## Support

Si vous rencontrez des problèmes :
1. Vérifiez que vous exécutez PowerShell en tant qu'administrateur
2. Consultez les logs d'erreur détaillés
3. Redémarrez votre ordinateur après les installations
4. Vérifiez votre connexion internet et proxy si applicable