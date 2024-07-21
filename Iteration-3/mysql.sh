#!/bin/bash

# Source common functions and variables
source common.sh

# Set up logging with timestamped log file
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="/tmp/mysql_$TIMESTAMP.log"

# Function to handle errors
error_exit() {
    local line=$1
    local command=$2
    echo "Error on line $line: Command '$command' failed with exit code $?" 1>&2
    exit 1
}

# Trap errors and call error_exit with the line number and command that failed
trap 'error_exit $LINENO "$BASH_COMMAND"' ERR

# Install MySQL Server
HEADING "Installing MySQL Server"
dnf install mysql-server -y &>> "$LOG_FILE"
STAT $?

# Enable and Start MySQL Server
HEADING "Enabling and Starting MySQL Server"
systemctl enable mysqld &>> "$LOG_FILE"
systemctl start mysqld &>> "$LOG_FILE"
STAT $?

# Set the root User password with mysqladmin
HEADING "Setting root User password"
mysqladmin password 'ExpenseApp@1' || true  # Set root password with mysqladmin (suppress errors)
STAT $?

# Run mysql_secure_installation to secure MySQL installation
HEADING "Running mysql_secure_installation"
mysql --user=root --password='ExpenseApp@1' <<EOF
UPDATE mysql.user SET Password = PASSWORD('ExpenseApp@1') WHERE User = 'root';
FLUSH PRIVILEGES;
EOF
STAT $?

# Additional security settings with mysql_secure_installation non-interactively
echo "Securing MySQL installation non-interactively..."
mysql_secure_installation --password='ExpenseApp@1' <<EOF
y  # Remove anonymous users
n  # Disallow root login remotely
y  # Remove test database and access to it
y  # Reload privilege tables now
EOF
STAT $?

# Final success message
echo "MySQL server installation and setup completed successfully. Logs are saved in: $LOG_FILE"
