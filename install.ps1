# AI Image Generator Installation Script for Python 3.13 + CUDA 13.0
# Repository: https://github.com/laurentvv/ai-image-generator-pytorch.git
# This script creates a virtual environment and installs all required dependencies

Write-Host "===============================================" -ForegroundColor Green
Write-Host "STABLE DIFFUSION INSTALLATION SCRIPT" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Check if Python 3.13 is installed
Write-Host "`nChecking for Python 3.13..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($pythonVersion -match "Python 3\.13") {
    Write-Host "✓ Python 3.13 found: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Python 3.13 not found or not in PATH!" -ForegroundColor Red
    Write-Host "Please install Python 3.13 with 'Add to PATH' option checked." -ForegroundColor Red
    Pause
    exit 1
}

# Check if virtual environment module is available
Write-Host "`nCreating virtual environment..." -ForegroundColor Yellow
try {
    python -m venv .venv
    Write-Host "✓ Virtual environment created successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to create virtual environment" -ForegroundColor Red
    Pause
    exit 1
}

# Activate the virtual environment
Write-Host "`nActivating virtual environment..." -ForegroundColor Yellow
& .venv\Scripts\Activate.ps1
if ($?) {
    Write-Host "✓ Virtual environment activated" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to activate virtual environment" -ForegroundColor Red
    Pause
    exit 1
}

# Upgrade pip
Write-Host "`nUpgrading pip..." -ForegroundColor Yellow
& python -m pip install --upgrade pip setuptools wheel
if ($?) {
    Write-Host "✓ pip upgraded successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to upgrade pip" -ForegroundColor Red
    Pause
    exit 1
}

# Install PyTorch with CUDA 13.0 from the special URL
Write-Host "`nInstalling PyTorch with CUDA 13.0 (this may take several minutes)..." -ForegroundColor Yellow
& pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130
if ($?) {
    Write-Host "✓ PyTorch with CUDA 13.0 installed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install PyTorch with CUDA 13.0" -ForegroundColor Red
    Pause
    exit 1
}

# Install other dependencies from requirements.txt
Write-Host "`nInstalling other dependencies from requirements.txt..." -ForegroundColor Yellow
if (Test-Path "requirements.txt") {
    & pip install -r requirements.txt
    if ($?) {
        Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to install dependencies from requirements.txt" -ForegroundColor Red
        Pause
        exit 1
    }
} else {
    Write-Host "✗ requirements.txt file not found!" -ForegroundColor Red
    Pause
    exit 1
}

# Verify the installation
Write-Host "`nVerifying installation..." -ForegroundColor Yellow
$testResult = & python test_pytorch.py
Write-Host $testResult -ForegroundColor Cyan

Write-Host "`n===============================================" -ForegroundColor Green
Write-Host "INSTALLATION COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host "To run the image generator, use: python main.py" -ForegroundColor Yellow
Write-Host "To activate the environment in the future: .venv\Scripts\Activate.ps1" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Green

Pause