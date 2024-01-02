#!/bin/bash

# Install NodeJS and NPM using apt-get
sudo apt update
sudo apt install nodejs npm

# Print the installed versions
echo "NodeJS version: $(node -v)"
echo "NPM version: $(npm -v)"

# Download the artifact file using curl
curl -O https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz

# Unzip the downloaded file
tar -xvzf bootcamp-node-envvars-project-1.0.0.tgz

# Set the environment variables
export APP_ENV=dev
export DB_USER=myuser
export DB_PWD=mysecret

# Change into the unzipped package directory
cd bootcamp-node-envvars-project

# Get the log directory from the parameter input
log_directory=$1

# Check if the log directory exists or not
if [ -d "$log_directory" ]; then
  # Log directory exists
  echo "Log directory $log_directory already exists."
else
  # Log directory does not exist
  echo "Log directory $log_directory does not exist. Creating it now."
  # Create the log directory
  mkdir -p $log_directory
fi

# Set the LOG_DIR environment variable to the absolute path of the log directory
export LOG_DIR=$(realpath $log_directory)

# Run the NodeJS application in the background
npm install
node server.js &

# Get the process ID of the NodeJS application
pid=$!

# Wait for a few seconds to let the application start
sleep 5

# Check if the process is still running
if ps -p $pid > /dev/null; then
  # Process is running
  echo "Node app is running with PID: $pid"
  # Get the port number from the server.js file
  port=$(grep -oP 'app.listen\(\K\d+' server.js)
  # Print the port number
  echo "Node app is listening on port: $port"
else
  # Process is not running
  echo "Node app is not running. Please check the logs for errors."
fi