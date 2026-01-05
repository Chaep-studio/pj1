#!/bin/bash

# Next.js Deployment Script
# This script helps with various deployment tasks

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Next.js Deployment Helper${NC}"
echo "================================"
echo ""

# Check if script is run as root for certain operations
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}Warning: Running as root may not be necessary for all operations${NC}"
fi

# Function to show help
show_help() {
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  build           Build the application for production"
    echo "  start           Start the production server"
    echo "  docker          Build and run Docker container"
    echo "  vercel          Deploy to Vercel (requires vercel CLI)"
    echo "  test            Test the production build locally"
    echo "  help            Show this help message"
    echo ""
}

# Function to build the application
build_app() {
    echo -e "${GREEN}Building application...${NC}"
    npm run build
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Build completed successfully!${NC}"
    else
        echo -e "${RED}Build failed!${NC}"
        exit 1
    fi
}

# Function to start the production server
start_server() {
    echo -e "${GREEN}Starting production server...${NC}"
    echo "Server will be available at http://localhost:3000"
    echo "Press Ctrl+C to stop the server"
    echo ""
    node .next/standalone/server.js
}

# Function to build and run Docker container
docker_deploy() {
    echo -e "${GREEN}Building Docker image...${NC}"
    docker build -t nextjs-app .
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Docker image built successfully!${NC}"
        echo -e "${GREEN}Starting container...${NC}"
        docker run -d -p 3000:3000 --name nextjs-app nextjs-app
        echo -e "${GREEN}Container started!${NC}"
        echo "Your application is running at http://localhost:3000"
    else
        echo -e "${RED}Docker build failed!${NC}"
        exit 1
    fi
}

# Function to deploy to Vercel
vercel_deploy() {
    if ! command -v vercel &> /dev/null; then
        echo -e "${RED}Vercel CLI is not installed. Please install it first:${NC}"
        echo "npm install -g vercel"
        exit 1
    fi
    
    echo -e "${GREEN}Deploying to Vercel...${NC}"
    vercel
}

# Function to test the production build
test_build() {
    echo -e "${GREEN}Testing production build...${NC}"
    
    # Start server in background
    node .next/standalone/server.js &
    SERVER_PID=$!
    
    # Wait for server to start
    sleep 5
    
    # Test the server
    echo "Testing http://localhost:3000..."
    curl -s -o /dev/null -w "%{http_code}" http://localhost:3000
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Server is running successfully!${NC}"
    else
        echo -e "${RED}Server test failed!${NC}"
    fi
    
    # Stop the test server
    kill $SERVER_PID
}

# Main script logic
case "$1" in
    build)
        build_app
        ;;
    start)
        start_server
        ;;
    docker)
        docker_deploy
        ;;
    vercel)
        vercel_deploy
        ;;
    test)
        test_build
        ;;
    help|--help|-h|*)
        show_help
        ;;
esac