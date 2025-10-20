#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Terraform - Order Service Infrastructure" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

$action = $args[0]

if (-not $action) {
    Write-Host "Usage: ./deploy.ps1 [init|plan|apply|destroy|output]" -ForegroundColor Yellow
    exit 1
}

try {
    switch ($action) {
        "init" {
            Write-Host "Initializing Terraform..." -ForegroundColor Yellow
            Write-Host ""
            terraform init
            Write-Host ""
            Write-Host "✓ Terraform initialized successfully!" -ForegroundColor Green
        }

        "plan" {
            Write-Host "Planning Terraform changes..." -ForegroundColor Yellow
            Write-Host ""
            terraform plan -out=tfplan
            Write-Host ""
            Write-Host "✓ Plan created successfully!" -ForegroundColor Green
            Write-Host "Review the plan and run: ./deploy.ps1 apply" -ForegroundColor Cyan
        }

        "apply" {
            Write-Host "Applying Terraform changes..." -ForegroundColor Yellow
            Write-Host ""

            if (Test-Path "tfplan") {
                terraform apply tfplan
                Remove-Item tfplan
            } else {
                terraform apply
            }

            Write-Host ""
            Write-Host "✓ Infrastructure deployed successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "View outputs: ./deploy.ps1 output" -ForegroundColor Cyan
        }

        "destroy" {
            Write-Host "⚠ WARNING: This will destroy all infrastructure!" -ForegroundColor Red
            $confirm = Read-Host "Type 'yes' to confirm"

            if ($confirm -eq "yes") {
                Write-Host ""
                Write-Host "Destroying infrastructure..." -ForegroundColor Yellow
                terraform destroy
                Write-Host ""
                Write-Host "✓ Infrastructure destroyed successfully!" -ForegroundColor Green
            } else {
                Write-Host "Destruction cancelled." -ForegroundColor Yellow
            }
        }

        "output" {
            Write-Host "Terraform Outputs:" -ForegroundColor Cyan
            Write-Host ""
            terraform output
        }

        "validate" {
            Write-Host "Validating Terraform configuration..." -ForegroundColor Yellow
            Write-Host ""
            terraform validate
            Write-Host ""
            Write-Host "✓ Configuration is valid!" -ForegroundColor Green
        }

        "fmt" {
            Write-Host "Formatting Terraform files..." -ForegroundColor Yellow
            Write-Host ""
            terraform fmt -recursive
            Write-Host ""
            Write-Host "✓ Files formatted successfully!" -ForegroundColor Green
        }

        default {
            Write-Host "Unknown action: $action" -ForegroundColor Red
            Write-Host "Usage: ./deploy.ps1 [init|plan|apply|destroy|output|validate|fmt]" -ForegroundColor Yellow
            exit 1
        }
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}
