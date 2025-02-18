echo -e "\e[36m>>>>>>>>>> Enable nodejs Version <<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:20 -y

echo -e "\e[36m>>>>>>>>>> Install nodejs <<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>> Copy Service File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>> Setup an app Directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Download the application code <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[36m>>>>>>>>>> Unzip the application code <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>>> download the dependencies <<<<<<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>>>>>> Load the service <<<<<<<<<<\e[0m"
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[36m>>>>>>>>>> Copy Mongo Repo File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Insatll mongodb Client <<<<<<<<<<\e[0m"
dnf install mongodb-mongosh -y

echo -e "\e[36m>>>>>>>>>> Load schema <<<<<<<<<<\e[0m"
mongosh --host mongodb-dev.meghadevops.site </app/schema/catalogue.js

echo -e "\e[36m>>>>>>>>>> Restart catalogue <<<<<<<<<<\e[0m"
systemctl restart catalogue