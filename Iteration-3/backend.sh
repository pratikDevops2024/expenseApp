#!/bin/bash

# Function to handle errors
error_exit() {
    echo "Error on line $1: Command '$2' failed with exit code $3" 1>&2
    exit 1
}

# Trap errors and call error_exit with the line number and command that failed
trap 'error_exit $LINENO "$BASH_COMMAND" $?' ERR

# Source common functions and variables
source common.sh

# Set up logging with timestamped log file
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="/tmp/backend_$TIMESTAMP.log"

# Function to execute command with error handling
execute_command() {
    local command="$1"
    local description="$2"

    # Log heading
    HEADING "$description"

    # Execute command, append output to log file
    eval "$command" &>> "$LOG_FILE"

    # Check command exit status
#    if [ $? -eq 0 ]; then
#        STAT 0
#    else
#        STAT 1
#    fi
}

# Commands with error handling
execute_command "dnf module disable nodejs -y" "Disabling the default Node Version"
execute_command "dnf module enable nodejs:20 -y" "Enabling NodeJS 20"
execute_command "dnf install nodejs -y" "Installing NodeJS"
execute_command "id expense || useradd expense" "Adding expense user"
execute_command "cp backend.service /etc/systemd/system/backend.service" "Copying backend server files"
execute_command "rm -rf /app" "Deleting existing application directory"
execute_command "mkdir /app" "Creating application directory"
execute_command "curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip" "Downloading Backend Code"
execute_command "cd /app && unzip /tmp/backend.zip" "Extracting Backend Code"
execute_command "cd /app && npm install" "Downloading NodeJS App Dependencies"
execute_command "dnf install mysql -y" "Installing MySQL Client"
execute_command "command to simulate failure" "command to simulate failure"
execute_command "mysql -h localhost -uroot -pExpenseApp@1 < /app/schema/backend.sql" "Loading Schema"
execute_command "systemctl daemon-reload && systemctl enable backend && systemctl restart backend" "Starting Backend Server"

# Final success message
echo "Backend setup completed successfully. Logs are saved in: $LOG_FILE"
