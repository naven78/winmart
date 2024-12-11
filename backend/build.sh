#!/bin/bash

# Create dist directory
mkdir -p dist

# Copy necessary files
cp server.js database.xml package.json dist/

# Install production dependencies
cd dist
npm install --production

echo "Backend build completed. Production files are in the dist directory."
