#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Kubernetes Deployment - Order Service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

$action = $args[0]

if (-not $action) {
    Write-Host "Usage: ./deploy.ps1 [apply|delete|status|logs|port-forward]" -ForegroundColor Yellow
    exit 1
}

try {
    switch ($action) {
        "apply" {
            Write-Host "Applying Kubernetes manifests..." -ForegroundColor Yellow
            Write-Host ""

            Write-Host "1. Creating namespace..." -ForegroundColor Cyan
            kubectl apply -f namespace.yaml

            Write-Host "2. Creating ConfigMap..." -ForegroundColor Cyan
            kubectl apply -f configmap.yaml

            Write-Host "3. Creating Secret..." -ForegroundColor Cyan
            Write-Host "   ⚠ Remember to update secret.yaml with your credentials!" -ForegroundColor Yellow
            kubectl apply -f secret.yaml

            Write-Host "4. Creating Deployment..." -ForegroundColor Cyan
            kubectl apply -f deployment.yaml

            Write-Host "5. Creating Service..." -ForegroundColor Cyan
            kubectl apply -f service.yaml

            Write-Host "6. Creating HPA..." -ForegroundColor Cyan
            kubectl apply -f hpa.yaml

            Write-Host ""
            Write-Host "✓ Kubernetes resources deployed successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Check status: ./deploy.ps1 status" -ForegroundColor Cyan
        }

        "delete" {
            Write-Host "Deleting Kubernetes resources..." -ForegroundColor Yellow
            Write-Host ""

            kubectl delete -f hpa.yaml --ignore-not-found
            kubectl delete -f service.yaml --ignore-not-found
            kubectl delete -f deployment.yaml --ignore-not-found
            kubectl delete -f secret.yaml --ignore-not-found
            kubectl delete -f configmap.yaml --ignore-not-found
            kubectl delete -f namespace.yaml --ignore-not-found

            Write-Host ""
            Write-Host "✓ Kubernetes resources deleted successfully!" -ForegroundColor Green
        }

        "status" {
            Write-Host "Kubernetes Resources Status:" -ForegroundColor Cyan
            Write-Host ""

            Write-Host "Namespace:" -ForegroundColor Yellow
            kubectl get namespace order-service

            Write-Host ""
            Write-Host "Deployments:" -ForegroundColor Yellow
            kubectl get deployments -n order-service

            Write-Host ""
            Write-Host "Pods:" -ForegroundColor Yellow
            kubectl get pods -n order-service

            Write-Host ""
            Write-Host "Services:" -ForegroundColor Yellow
            kubectl get services -n order-service

            Write-Host ""
            Write-Host "HPA:" -ForegroundColor Yellow
            kubectl get hpa -n order-service
        }

        "logs" {
            Write-Host "Fetching pod logs..." -ForegroundColor Yellow
            kubectl logs -n order-service -l app=order-service --tail=100 -f
        }

        "port-forward" {
            Write-Host "Setting up port forwarding..." -ForegroundColor Yellow
            Write-Host "Access service at: http://localhost:8080" -ForegroundColor Cyan
            Write-Host ""
            kubectl port-forward -n order-service service/order-service 8080:80
        }

        default {
            Write-Host "Unknown action: $action" -ForegroundColor Red
            Write-Host "Usage: ./deploy.ps1 [apply|delete|status|logs|port-forward]" -ForegroundColor Yellow
            exit 1
        }
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}
