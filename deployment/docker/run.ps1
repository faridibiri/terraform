#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Docker Compose - Order Service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

$action = $args[0]

if (-not $action) {
    $action = "up"
}

Write-Host "Action: $action" -ForegroundColor Yellow
Write-Host ""

try {
    switch ($action) {
        "up" {
            Write-Host "Starting services..." -ForegroundColor Yellow
            docker-compose up -d
            Write-Host ""
            Write-Host "✓ Services started successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "View logs: docker-compose logs -f" -ForegroundColor Cyan
            Write-Host "Stop services: ./run.ps1 down" -ForegroundColor Cyan
        }
        "down" {
            Write-Host "Stopping services..." -ForegroundColor Yellow
            docker-compose down
            Write-Host ""
            Write-Host "✓ Services stopped successfully!" -ForegroundColor Green
        }
        "logs" {
            docker-compose logs -f
        }
        "restart" {
            Write-Host "Restarting services..." -ForegroundColor Yellow
            docker-compose restart
            Write-Host ""
            Write-Host "✓ Services restarted successfully!" -ForegroundColor Green
        }
        "ps" {
            docker-compose ps
        }
        default {
            Write-Host "Usage: ./run.ps1 [up|down|logs|restart|ps]" -ForegroundColor Yellow
            exit 1
        }
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}
