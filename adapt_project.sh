#!/bin/bash

# Script to adapt the project template to a new project name
# Usage: ./adapt_project.sh NEW_PROJECT_NAME
# Example: ./adapt_project.sh MyProject

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    echo "Usage: $0 NEW_PROJECT_NAME"
    echo "Example: $0 MyProject"
    exit 1
fi

NEW_PROJECT_NAME="$1"

# Create project name with 'Project' suffix
NEW_PROJECT_BASE="$NEW_PROJECT_NAME"
NEW_PROJECT_FULL="${NEW_PROJECT_NAME}Project"

# Create lowercase version
NEW_PROJECT_LOWER=$(echo "$NEW_PROJECT_BASE" | tr '[:upper:]' '[:lower:]')

# Old values
OLD_PROJECT_FULL="FR_STT_ProjectTemplateProject"
OLD_PROJECT_BASE="FR_STT_ProjectTemplate"
OLD_PROJECT_LOWER="fr_stt_projecttemplate"

echo -e "${YELLOW}Adapting project template...${NC}"
echo "Old project name: $OLD_PROJECT_FULL"
echo "New project name: $NEW_PROJECT_FULL"
echo "New project base: $NEW_PROJECT_BASE"
echo "New project lower: $NEW_PROJECT_LOWER"
echo ""

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Step 1: Replace strings in all files (except .git directory)
echo -e "${YELLOW}Step 1: Replacing strings in files...${NC}"
find "$SCRIPT_DIR" -type f -not -path '*/.git/*' -not -name "adapt_project.sh" | while read file; do
    if file "$file" | grep -q "text"; then
        # Replace with full name
        sed -i '' "s/${OLD_PROJECT_FULL}/${NEW_PROJECT_FULL}/g" "$file"
        # Replace with base name
        sed -i '' "s/${OLD_PROJECT_BASE}/${NEW_PROJECT_BASE}/g" "$file"
        # Replace with lowercase name
        sed -i '' "s/${OLD_PROJECT_LOWER}/${NEW_PROJECT_LOWER}/g" "$file"
        echo "  Updated: $file"
    fi
done

# Step 2: Rename directories
echo -e "${YELLOW}Step 2: Renaming directories...${NC}"

# Rename the main namespace directory if it exists
if [ -d "$SCRIPT_DIR/ns/project/$OLD_PROJECT_LOWER" ]; then
    mv "$SCRIPT_DIR/ns/project/$OLD_PROJECT_LOWER" "$SCRIPT_DIR/ns/project/$NEW_PROJECT_LOWER"
    echo "  Renamed: ns/project/$OLD_PROJECT_LOWER → ns/project/$NEW_PROJECT_LOWER"
fi

# Step 3: Rename configuration file
echo -e "${YELLOW}Step 3: Renaming configuration file...${NC}"
if [ -f "$SCRIPT_DIR/config/scaffolding/${OLD_PROJECT_FULL}.yml" ]; then
    mv "$SCRIPT_DIR/config/scaffolding/${OLD_PROJECT_FULL}.yml" "$SCRIPT_DIR/config/scaffolding/${NEW_PROJECT_FULL}.yml"
    echo "  Renamed: config/scaffolding/${OLD_PROJECT_FULL}.yml → config/scaffolding/${NEW_PROJECT_FULL}.yml"
fi

echo ""
echo -e "${GREEN}✓ Project adaptation completed successfully!${NC}"
echo ""

