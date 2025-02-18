echo -e "\e[36m>>>>>>>>>> Enable 20 version and install list <<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:20 -y

echo -e "\e[36m>>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>> Copy user service file <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>>> setup an app directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Download the application code <<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
cd /app
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>>> Download the Dependencies <<<<<<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>>>>>> Load the service <<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>> Restart the service <<<<<<<<<<\e[0m"
systemctl enable cart
systemctl restart cart