HEADING() {
  echo -e "\e[35m$*\e[0m" # Magenta color for the content
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"  # Green color for Success
  else
    echo -e "\e[31mFailure\e[0m"  # Red color for Failure
    exit 2
  fi
}

#Install Nginx
HEADING Installing Nginx
dnf install nginx -y
STAT $?

#Start & Enable Nginx service
HEADING Starting & Enableing Nginx service
systemctl enable nginx
systemctl start nginx
STAT $?

#Remove the default content that web server is serving.
HEADING Starting & Enableing Nginx service
rm -rf /usr/share/nginx/html/*
STAT $?

#Create Nginx Reverse Proxy Configuration.
HEADING Starting & Enableing Nginx service
cp expense.conf /etc/nginx/default.d/expense.conf
STAT $?

#Download the frontend content
HEADING Downloading the frontend content
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip
STAT $?

#Extract the frontend content.
HEADING Extracting the Frontend content
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
STAT $?

HEADING Restarting the Nginx Server
systemctl restart nginx
STAT $?
