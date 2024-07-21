source common.sh

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="/tmp/backend_$TIMESTAMP.log"

#Disabled the default Node Version
HEADING Disabling the default Node Version
dnf module disable nodejs -y &>>"$LOG_FILE"
STAT $?

#Enable NodeJS 20
HEADING Enabling the default Node Version
dnf module enable nodejs:20 -y &>>"$LOG_FILE"
STAT $?

#Install NodeJS
HEADING Installing Node 
dnf install nodejs -y &>>"$LOG_FILE"
STAT $?

#Add Expense User
HEADING Adding expense
id expense &>>"$LOG_FILE"
if [ $1 -ne 0 ]; then
    useradd expense &>>"$LOG_FILE"
fi
STAT $?

#Add the backend service file to run the app as a service.
HEADING Copying the backend server files
cp backend.service /etc/systemd/system/backend.service &>>"$LOG_FILE"
STAT $?

#Delete Existing Application Directory
HEADING Deleting Existing Application Directory
rm -rf /app &>>"$LOG_FILE"
STAT $?

#Create Application Directory
HEADING Creatung Existing Application Directory
mkdir /app
STAT $?

#Download Backend Code
HEADING Downloading Backend Code
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>"$LOG_FILE"
STAT $?

#Extract Backend code
HEADING Extracting Backend Code
cd /app
unzip /tmp/backend.zip &>>"$LOG_FILE"
STAT $?

#Download NodeJS App Dependencies
HEADING Downloading NodeJS App Dependencies
npm install &>>"$LOG_FILE"
STAT $?

#Install MySQL Client
HEADING Installing MySQL Client
dnf install mysql -y &>>"$LOG_FILE"
STAT $?

#Load Schema
HEDING Loading Schema
mysql -h localhost -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>"$LOG_FILE"
STAT $?

#Start Backend Service
HEADING Starting the Backend Server
systemctl daemon-reload &>>"$LOG_FILE"
systemctl enable backend &>>"$LOG_FILE"
systemctl restart backend &>>"$LOG_FILE"
STAT $?
