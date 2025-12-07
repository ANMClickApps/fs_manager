#!/bin/bash

# ============================================
# Flutter Release Build Script
# ============================================
# Universal script for building signed Flutter release App Bundles
# Works with any Flutter project
#
# Usage: ./build_release.sh
# 
# The script will interactively prompt for:
# 1. Path to password file (pass.env)
# 2. Path to keystore file (.jks or .keystore)
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to prompt for file path with validation
prompt_for_file() {
    local prompt_message="$1"
    local file_description="$2"
    local file_path=""
    
    while true; do
        echo ""
        print_info "$prompt_message"
        echo -e "${YELLOW}Tip: You can drag and drop the file into terminal${NC}"
        echo ""
        printf "${GREEN}Path:${NC} "
        read -r file_path
        
        # Expand tilde to home directory
        file_path="${file_path/#\~/$HOME}"
        
        # Remove quotes if present (from drag-and-drop)
        file_path="${file_path%\"}"
        file_path="${file_path#\"}"
        file_path="${file_path%\'}"
        file_path="${file_path#\'}"
        
        # Trim whitespace
        file_path=$(echo "$file_path" | xargs)
        
        if [[ -f "$file_path" ]]; then
            print_success "$file_description found: $file_path"
            echo "$file_path"
            return 0
        else
            print_error "File not found: $file_path"
            print_warning "Please enter a valid file path or drag and drop the file."
        fi
    done
}

# Welcome banner
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Flutter Release Build Script        ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo ""
print_info "This script will build a signed release App Bundle for Google Play"
echo ""

# Key properties file path
KEY_PROPERTIES_FILE="android/key.properties"

# Step 1: Prompt for password file
echo -e "${BLUE}═══ Step 1/6: Password File ═══${NC}"
print_info "The password file should contain your keystore credentials:"
echo -e "${YELLOW}storePassword=YOUR_PASSWORD${NC}"
echo -e "${YELLOW}keyPassword=YOUR_PASSWORD${NC}"
echo -e "${YELLOW}keyAlias=upload${NC}"

PASSWORD_FILE=$(prompt_for_file "Enter the path to your password file (pass.env):" "Password file")

# Step 2: Load credentials from password file
echo ""
echo -e "${BLUE}═══ Step 2/6: Load Credentials ═══${NC}"
print_info "Loading credentials from password file..."

# Source the password file
source "$PASSWORD_FILE"

# Validate required variables
if [ -z "$storePassword" ] || [ -z "$keyPassword" ] || [ -z "$keyAlias" ]; then
    print_error "Missing required credentials in password file"
    echo ""
    echo "Your password file must contain:"
    echo "  storePassword=YOUR_PASSWORD"
    echo "  keyPassword=YOUR_PASSWORD"
    echo "  keyAlias=upload"
    exit 1
fi

print_success "Credentials loaded successfully"

# Step 3: Prompt for keystore file
echo ""
echo -e "${BLUE}═══ Step 3/6: Keystore File ═══${NC}"
print_info "Your keystore file should be a .jks or .keystore file"

KEYSTORE_PATH=$(prompt_for_file "Enter the path to your keystore file:" "Keystore")

# Step 4: Create temporary key.properties file
echo ""
echo -e "${BLUE}═══ Step 4/6: Configure Signing ═══${NC}"
print_info "Creating temporary key.properties file..."

cat > "$KEY_PROPERTIES_FILE" << EOF
storePassword=$storePassword
keyPassword=$keyPassword
keyAlias=$keyAlias
storeFile=$KEYSTORE_PATH
EOF

print_success "Signing configuration created"

# Step 5: Clean and prepare
echo ""
echo -e "${BLUE}═══ Step 5/6: Prepare Build ═══${NC}"

print_info "Cleaning previous builds..."
flutter clean
print_success "Clean complete"

echo ""
print_info "Getting dependencies..."
flutter pub get
print_success "Dependencies resolved"

# Step 6: Build release App Bundle
echo ""
echo -e "${BLUE}═══ Step 6/6: Build Release ═══${NC}"
print_info "Building signed release App Bundle..."
echo ""

flutter build appbundle --release

# Check build result
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       BUILD SUCCESSFUL! ✓              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    print_success "Your signed App Bundle is ready!"
    echo ""
    echo -e "${YELLOW}📦 Output location:${NC}"
    echo "   build/app/outputs/bundle/release/app-release.aab"
    echo ""
    echo -e "${YELLOW}📋 Next steps:${NC}"
    echo "   1. Test the release build: flutter install --release"
    echo "   2. Upload to Google Play Console"
    echo "   3. Add release notes and publish"
    echo ""
else
    echo ""
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║         BUILD FAILED ✗                 ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    echo ""
    print_error "Build failed. Check the error messages above."
    echo ""
fi

# Cleanup: Remove temporary key.properties file
print_info "Cleaning up temporary files..."
rm -f "$KEY_PROPERTIES_FILE"
print_success "Cleanup complete"

echo ""
