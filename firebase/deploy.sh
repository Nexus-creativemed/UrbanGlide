#!/bin/bash
# Firebase Deployment Script for Urban Glide
# This script deploys Cloud Functions and Firestore Rules

echo "================================"
echo "Urban Glide - Firebase Deployment"
echo "================================"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null
then
    echo "❌ Firebase CLI not found. Installing..."
    npm install -g firebase-tools
fi

echo "✅ Firebase CLI found"
echo ""

# Check if logged in
echo "📝 Checking Firebase authentication..."
firebase projects:list > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Not logged into Firebase. Run: firebase login"
    exit 1
fi
echo "✅ Logged into Firebase"
echo ""

# Select project
echo "🔍 Verifying project: urban-glide-transport-25"
firebase use urban-glide-transport-25
echo ""

# Deploy Cloud Functions
echo "📤 Deploying Cloud Functions..."
cd firebase/functions
npm install
cd ..
firebase deploy --only functions
echo ""

# Deploy Firestore Rules
echo "📋 Deploying Firestore Rules..."
firebase deploy --only firestore:rules
echo ""

# Verify deployment
echo "✅ Deployment Complete!"
echo ""
echo "📊 Deployment Summary:"
firebase functions:list
echo ""
echo "🔐 Firestore Rules Status:"
firebase rules:list
echo ""
echo "✨ Firebase initialization complete!"
echo "Next: Configure google-services.json and Google Maps API keys"
