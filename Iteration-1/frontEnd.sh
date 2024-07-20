#Switch to root User
sudo -i

#Install Nginx
dnf install nginx -y

#Start & Enable Nginx service
systemctl enable nginx
systemctl start nginx

#Remove the default content that web server is serving.
rm -rf /usr/share/nginx/html/*

#Download the frontend content
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip

#Extract the frontend content.
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#Create Nginx Reverse Proxy Configuration.
cp expense.conf /etc/nginx/default.d/expense.conf

systemctl restart nginx