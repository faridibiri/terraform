#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AWS EKS - Configure kubectl" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

param(
    [string]$ClusterName = "order-service-cluster",
    [string]$Region = "us-east-1"
)

try {
    Write-Host "Configuration:" -ForegroundColor Yellow
    Write-Host "  Cluster: $ClusterName" -ForegroundColor White
    Write-Host "  Region: $Region" -ForegroundColor White
    Write-Host ""

    Write-Host "Updating kubeconfig..." -ForegroundColor Cyan
    aws eks update-kubeconfig --name $ClusterName --region $Region

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to update kubeconfig"
    }

    Write-Host ""
    Write-Host "✓ Kubeconfig updated successfully!" -ForegroundColor Green
    Write-Host ""

    Write-Host "Verifying connection..." -ForegroundColor Cyan
    kubectl cluster-info

    Write-Host ""
    Write-Host "Getting nodes..." -ForegroundColor Cyan
    kubectl get nodes

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ EKS cluster configured successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green

} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}
