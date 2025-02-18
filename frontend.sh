echo -e "\e[36m>>>>>>>>>> Install nignx<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[36m>>>>>>>>>> Enable nignx<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx

echo -e "\e[36m>>>>>>>>>> Copy Roboshop Config File<<<<<<<<<<\e[0m"
cp /home/centos/Roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>> Download frontend Artifact<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>> Unzip the Artifact<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>> Restart nignx<<<<<<<<<<\e[0m"
systemctl restart nginx
