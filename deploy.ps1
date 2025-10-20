#!/usr/bin/env pwsh

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║           ORDER SERVICE - DEPLOYMENT MANAGER               ║" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

function Show-Menu {
    Write-Host "SELECT DEPLOYMENT TYPE:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] Docker (Local Development)" -ForegroundColor White
    Write-Host "      - Build and run with Docker Compose" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [2] Kubernetes (Local/On-Premise)" -ForegroundColor White
    Write-Host "      - Deploy to local Kubernetes cluster" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [3] Terraform (AWS Infrastructure)" -ForegroundColor White
    Write-Host "      - Provision AWS infrastructure (VPC, EKS, ECR)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [4] AWS (Complete AWS Deployment)" -ForegroundColor White
    Write-Host "      - Build, push to ECR, and deploy to EKS" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [5] Full Stack (Everything)" -ForegroundColor White
    Write-Host "      - Terraform → ECR → EKS deployment" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [0] Exit" -ForegroundColor Red
    Write-Host ""
}

function Deploy-Docker {
    Write-Host ""
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  DOCKER DEPLOYMENT" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Select action:" -ForegroundColor Yellow
    Write-Host "  [1] Build image"
    Write-Host "  [2] Start services"
    Write-Host "  [3] Stop services"
    Write-Host "  [4] View logs"
    Write-Host ""

    $action = Read-Host "Enter choice"

    Set-Location deployment/docker

    switch ($action) {
        "1" { & ./build.ps1 }
        "2" { & ./run.ps1 up }
        "3" { & ./run.ps1 down }
        "4" { & ./run.ps1 logs }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }

    Set-Location ../..
}

function Deploy-Kubernetes {
    Write-Host ""
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  KUBERNETES DEPLOYMENT" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Select action:" -ForegroundColor Yellow
    Write-Host "  [1] Apply manifests"
    Write-Host "  [2] Delete resources"
    Write-Host "  [3] Check status"
    Write-Host "  [4] View logs"
    Write-Host "  [5] Port forward"
    Write-Host ""

    $action = Read-Host "Enter choice"

    Set-Location deployment/kubernetes

    switch ($action) {
        "1" { & ./deploy.ps1 apply }
        "2" { & ./deploy.ps1 delete }
        "3" { & ./deploy.ps1 status }
        "4" { & ./deploy.ps1 logs }
        "5" { & ./deploy.ps1 port-forward }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }

    Set-Location ../..
}

function Deploy-Terraform {
    Write-Host ""
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  TERRAFORM INFRASTRUCTURE" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Select action:" -ForegroundColor Yellow
    Write-Host "  [1] Initialize"
    Write-Host "  [2] Plan changes"
    Write-Host "  [3] Apply changes"
    Write-Host "  [4] Destroy infrastructure"
    Write-Host "  [5] Show outputs"
    Write-Host "  [6] Validate configuration"
    Write-Host ""

    $action = Read-Host "Enter choice"

    Set-Location deployment/terraform

    switch ($action) {
        "1" { & ./deploy.ps1 init }
        "2" { & ./deploy.ps1 plan }
        "3" { & ./deploy.ps1 apply }
        "4" { & ./deploy.ps1 destroy }
        "5" { & ./deploy.ps1 output }
        "6" { & ./deploy.ps1 validate }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }

    Set-Location ../..
}

function Deploy-AWS {
    Write-Host ""
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  AWS DEPLOYMENT" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Select action:" -ForegroundColor Yellow
    Write-Host "  [1] Push image to ECR"
    Write-Host "  [2] Configure EKS access"
    Write-Host "  [3] Deploy to EKS"
    Write-Host ""

    $action = Read-Host "Enter choice"

    Set-Location deployment/aws

    switch ($action) {
        "1" { & ./ecr-push.ps1 }
        "2" { & ./eks-config.ps1 }
        "3" { & ./deploy-to-eks.ps1 }
        default { Write-Host "Invalid choice" -ForegroundColor Red }
    }

    Set-Location ../..
}

function Deploy-FullStack {
    Write-Host ""
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  FULL STACK DEPLOYMENT" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "⚠ This will deploy the complete stack to AWS" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Steps:" -ForegroundColor Cyan
    Write-Host "  1. Create AWS infrastructure (Terraform)" -ForegroundColor White
    Write-Host "  2. Build and push Docker image to ECR" -ForegroundColor White
    Write-Host "  3. Deploy application to EKS" -ForegroundColor White
    Write-Host ""

    $confirm = Read-Host "Continue? (yes/no)"

    if ($confirm -ne "yes") {
        Write-Host "Cancelled." -ForegroundColor Yellow
        return
    }

    try {
        Write-Host ""
        Write-Host "STEP 1: Creating infrastructure..." -ForegroundColor Cyan
        Set-Location deployment/terraform
        & ./deploy.ps1 init
        & ./deploy.ps1 apply
        Set-Location ../..

        Write-Host ""
        Write-Host "STEP 2: Building and pushing image..." -ForegroundColor Cyan
        Set-Location deployment/aws
        & ./ecr-push.ps1
        Set-Location ../..

        Write-Host ""
        Write-Host "STEP 3: Deploying to EKS..." -ForegroundColor Cyan
        Set-Location deployment/aws
        & ./deploy-to-eks.ps1
        Set-Location ../..

        Write-Host ""
        Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║                                                            ║" -ForegroundColor Green
        Write-Host "║          ✓ FULL STACK DEPLOYMENT SUCCESSFUL!               ║" -ForegroundColor Green
        Write-Host "║                                                            ║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green

    } catch {
        Write-Host ""
        Write-Host "✗ Deployment failed: $_" -ForegroundColor Red
        exit 1
    }
}

try {
    while ($true) {
        Show-Menu
        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            "1" { Deploy-Docker }
            "2" { Deploy-Kubernetes }
            "3" { Deploy-Terraform }
            "4" { Deploy-AWS }
            "5" { Deploy-FullStack }
            "0" {
                Write-Host ""
                Write-Host "Goodbye!" -ForegroundColor Cyan
                Write-Host ""
                exit 0
            }
            default {
                Write-Host ""
                Write-Host "Invalid choice. Please try again." -ForegroundColor Red
                Write-Host ""
            }
        }

        Write-Host ""
        Write-Host "Press any key to continue..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Clear-Host
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}
