#Install the Mysql Server
dnf module disable mysql -y

#Enable and Start the Mysql Server
systemctl enable mysqld
systemctl start mysqld

#Set the root User password
mysql_secure_installation --set-root-pass ExpenseApp@1