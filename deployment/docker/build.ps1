#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Docker Build - Order Service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

$BACKEND_DIR = "../../backend"
$IMAGE_NAME = "order-service"
$IMAGE_TAG = "latest"

Write-Host "Building Docker image..." -ForegroundColor Yellow
Write-Host "Image: ${IMAGE_NAME}:${IMAGE_TAG}" -ForegroundColor White
Write-Host ""

try {
    Set-Location $BACKEND_DIR

    docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ Docker image built successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Image details:" -ForegroundColor Cyan
        docker images | Select-String $IMAGE_NAME
    } else {
        throw "Docker build failed"
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error building Docker image: $_" -ForegroundColor Red
    exit 1
} finally {
    Set-Location -
}
