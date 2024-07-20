source common.sh

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="/tmp/expense_$TIMESTAMP.log"

#Install Nginx
HEADING Installing Nginx
dnf install nginx -y &>> "$LOG_FILE"
STAT $?

#Start & Enable Nginx service
HEADING "Starting & Enableing Nginx service"
systemctl enable nginx &>> "$LOG_FILE"
systemctl start nginx &>> "$LOG_FILE"
STAT $?

#Remove the default content that web server is serving.
HEADING "Starting & Enableing Nginx service "
rm -rf /usr/share/nginx/html/* &>> "$LOG_FILE"
STAT $?

#Create Nginx Reverse Proxy Configuration.
HEADING "Starting & Enableing Nginx service"
cp expense.conf /etc/nginx/default.d/expense.conf &>> "$LOG_FILE"
STAT $?

#Download the frontend content
HEADING Downloading the frontend content
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>> "$LOG_FILE"
STAT $?

#Extract the frontend content.
HEADING Extracting the Frontend content
cd /usr/share/nginx/html &>> "$LOG_FILE"
unzip /tmp/frontend.zip &>> "$LOG_FILE"
STAT $?

HEADING Restarting the Nginx Server
systemctl restart nginx &>> "$LOG_FILE"
STAT $?
