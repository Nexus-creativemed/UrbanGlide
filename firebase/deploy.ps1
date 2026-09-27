# Firebase Deployment Script for Urban Glide (Windows)
# This script deploys Cloud Functions and Firestore Rules

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Urban Glide - Firebase Deployment" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if Firebase CLI is installed
Write-Host "📝 Checking Firebase CLI..." -ForegroundColor Yellow
$firebaseCheck = firebase --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Firebase CLI not found. Installing..." -ForegroundColor Red
    npm install -g firebase-tools
} else {
    Write-Host "✅ Firebase CLI found: $firebaseCheck" -ForegroundColor Green
}

Write-Host ""

# Check if logged in
Write-Host "📝 Checking Firebase authentication..." -ForegroundColor Yellow
$projectList = firebase projects:list 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Not logged into Firebase. Run: firebase login" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Logged into Firebase" -ForegroundColor Green
Write-Host ""

# Select project
Write-Host "🔍 Verifying project: urban-glide-transport-25" -ForegroundColor Yellow
firebase use urban-glide-transport-25
Write-Host ""

# Deploy Cloud Functions
Write-Host "📤 Deploying Cloud Functions..." -ForegroundColor Yellow
Push-Location firebase/functions
npm install
Pop-Location
firebase deploy --only functions
Write-Host ""

# Deploy Firestore Rules
Write-Host "📋 Deploying Firestore Rules..." -ForegroundColor Yellow
firebase deploy --only firestore:rules
Write-Host ""

# Verify deployment
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Deployment Summary:" -ForegroundColor Cyan
firebase functions:list
Write-Host ""
Write-Host "🔐 Firestore Rules Status:" -ForegroundColor Cyan
firebase rules:list
Write-Host ""
Write-Host "✨ Firebase initialization complete!" -ForegroundColor Green
Write-Host "Next: Configure google-services.json and Google Maps API keys" -ForegroundColor Yellow
