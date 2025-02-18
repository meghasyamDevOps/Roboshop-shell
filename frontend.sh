echo -e "\e[35m>>>>>>>>>> Install Nginx <<<<<<<<<<\e[0m"
dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y

echo -e "\e[35m>>>>>>>>>> Start & Enable Nginx service <<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx

echo -e "\e[35m>>>>>>>>>> Copy the service File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/nginx.conf /etc/nginx/nginx.conf

echo -e "\e[35m>>>>>>>>>> Remove the default content  <<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35m>>>>>>>>>> Download the frontend content <<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

echo -e "\e[35m>>>>>>>>>> Extract the frontend content <<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35m>>>>>>>>>> Restart Nginx Service <<<<<<<<<<\e[0m"
systemctl restart nginx