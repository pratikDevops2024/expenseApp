source common.sh

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="/tmp/mysql_$TIMESTAMP.log"

#Install the Mysql Server
HEADING Installing Mysql Server
dnf install mysql-server -y &>>"$LOG_FILE"
STAT $?

#Enable and Start the Mysql Server
HEADING Enable and Start the Mysql Server
systemctl enable mysqld &>>"$LOG_FILE"
systemctl start mysqld &>>"$LOG_FILE"
STAT $?

# Set the root User password
HEADING Setting the root User password
mysqladmin password 'ExpenseApp@1' || true  # Set root password with mysqladmin (suppress errors)
STAT $?

# Run mysql_secure_installation to secure MySQL installation
HEADING Running mysql_secure_installation to secure MySQL installation
mysql_secure_installation --set-root-pass 'ExpenseApp@1' <<EOF

y  # Remove anonymous users
n  # Disallow root login remotely
y  # Remove test database and access to it
y  # Reload privilege tables now

EOF
STAT $?