#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AWS ECR - Push Docker Image" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

param(
    [string]$Region = "us-east-1",
    [string]$Repository = "order-service",
    [string]$Tag = "latest"
)

try {
    Write-Host "Configuration:" -ForegroundColor Yellow
    Write-Host "  Region: $Region" -ForegroundColor White
    Write-Host "  Repository: $Repository" -ForegroundColor White
    Write-Host "  Tag: $Tag" -ForegroundColor White
    Write-Host ""

    Write-Host "1. Getting AWS Account ID..." -ForegroundColor Cyan
    $accountId = aws sts get-caller-identity --query Account --output text

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get AWS account ID. Make sure AWS CLI is configured."
    }

    $ecrUrl = "${accountId}.dkr.ecr.${Region}.amazonaws.com"
    Write-Host "   Account ID: $accountId" -ForegroundColor Green
    Write-Host ""

    Write-Host "2. Logging into ECR..." -ForegroundColor Cyan
    aws ecr get-login-password --region $Region | docker login --username AWS --password-stdin $ecrUrl

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to login to ECR"
    }
    Write-Host "   ✓ Logged in successfully" -ForegroundColor Green
    Write-Host ""

    Write-Host "3. Building Docker image..." -ForegroundColor Cyan
    Set-Location ../../backend
    docker build -t "${Repository}:${Tag}" .

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to build Docker image"
    }
    Write-Host "   ✓ Image built successfully" -ForegroundColor Green
    Write-Host ""

    Write-Host "4. Tagging image for ECR..." -ForegroundColor Cyan
    docker tag "${Repository}:${Tag}" "${ecrUrl}/${Repository}:${Tag}"

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to tag image"
    }
    Write-Host "   ✓ Image tagged: ${ecrUrl}/${Repository}:${Tag}" -ForegroundColor Green
    Write-Host ""

    Write-Host "5. Pushing image to ECR..." -ForegroundColor Cyan
    docker push "${ecrUrl}/${Repository}:${Tag}"

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to push image to ECR"
    }
    Write-Host "   ✓ Image pushed successfully" -ForegroundColor Green
    Write-Host ""

    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ Image successfully pushed to ECR!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Image URI: ${ecrUrl}/${Repository}:${Tag}" -ForegroundColor Cyan

} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
} finally {
    Set-Location -
}
