#Disabled the default Node Version
dnf module disable nodejs -y

#Enable NodeJS 20
dnf module enable nodejs:20 -y

#Install NodeJS
dnf install nodejs -y

#Add Expense User
useradd expense

#Add the backend service file to run the app as a service.
cp backend.service /etc/systemd/system/backend.service

#Delete Existing Application Directory
rm -rf /app

#Create Application Directory
mkdir /app

#Download Backend Code
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip

#Extract Backend code
cd /app
unzip /tmp/backend.zip

#Download NodeJS App Dependencies
npm install

#Install MySQL Client
dnf install mysql -y

#Load Schema
mysql -h localhost -uroot -pExpenseApp@1 < /app/schema/backend.sql

#Start Backend Service
systemctl daemon-reload
systemctl enable backend
systemctl restart backend