#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AWS EKS - Deploy Order Service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

param(
    [string]$Region = "us-east-1",
    [string]$ClusterName = "order-service-cluster",
    [string]$Repository = "order-service",
    [string]$Tag = "latest"
)

try {
    Write-Host "Step 1: Configure EKS access..." -ForegroundColor Yellow
    & ../aws/eks-config.ps1 -ClusterName $ClusterName -Region $Region

    Write-Host ""
    Write-Host "Step 2: Get ECR image URI..." -ForegroundColor Yellow
    $accountId = aws sts get-caller-identity --query Account --output text
    $imageUri = "${accountId}.dkr.ecr.${Region}.amazonaws.com/${Repository}:${Tag}"
    Write-Host "   Image URI: $imageUri" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "Step 3: Update Kubernetes deployment..." -ForegroundColor Yellow
    Set-Location ../kubernetes

    $deploymentContent = Get-Content deployment.yaml -Raw
    $deploymentContent = $deploymentContent -replace "image: order-service:latest", "image: $imageUri"
    Set-Content -Path deployment.yaml -Value $deploymentContent

    Write-Host "   ✓ Deployment updated with ECR image" -ForegroundColor Green

    Write-Host ""
    Write-Host "Step 4: Apply Kubernetes manifests..." -ForegroundColor Yellow
    & ./deploy.ps1 apply

    Write-Host ""
    Write-Host "Step 5: Waiting for deployment to be ready..." -ForegroundColor Yellow
    kubectl rollout status deployment/order-service -n order-service

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ Application deployed to EKS!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Get service URL:" -ForegroundColor Cyan
    Write-Host "  kubectl get service order-service -n order-service" -ForegroundColor White

} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
} finally {
    Set-Location -
}
