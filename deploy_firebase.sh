#!/bin/zsh

# Smart Edu Firebase Deployment Script
# This script helps deploy Firebase configuration to your project

echo "Smart Edu Firebase Deployment Script"
echo "===================================="
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "Firebase CLI is not installed. Installing now..."
    npm install -g firebase-tools
    
    if [ $? -ne 0 ]; then
        echo "Failed to install Firebase CLI. Please install it manually."
        exit 1
    fi
fi

# Login to Firebase
echo "Logging in to Firebase..."
firebase login

# Initialize Firebase if needed
if [ ! -f "firebase.json" ]; then
    echo "Initializing Firebase project..."
    firebase init
else
    echo "Firebase project already initialized."
fi

# Deploy Firestore rules
echo "Deploying Firestore rules..."
firebase deploy --only firestore:rules

# Deploy Firestore indexes
echo "Deploying Firestore indexes..."
firebase deploy --only firestore:indexes

# Deploy Storage rules
echo "Deploying Storage rules..."
firebase deploy --only storage

# Deploy Hosting (if needed for web)
read -p "Do you want to deploy the web version to Firebase Hosting? (y/n): " deploy_web
if [[ $deploy_web == "y" || $deploy_web == "Y" ]]; then
    echo "Building web version..."
    flutter build web
    
    echo "Deploying to Firebase Hosting..."
    firebase deploy --only hosting
fi

echo ""
echo "Firebase deployment completed!"
echo "============================="
