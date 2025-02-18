echo -e "\e[35m>>>>>>>>>> Install Maven <<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[35m>>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[35m>>>>>>>>>> Copy Service File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[35m>>>>>>>>>> Setup an app directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[35m>>>>>>>>>> Download the application code <<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip
cd /app
unzip /tmp/shipping.zip

echo -e "\e[35m>>>>>>>>>> download the dependencies <<<<<<<<<<\e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[35m>>>>>>>>>> Load the service <<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[35m>>>>>>>>>> Start the service <<<<<<<<<<\e[0m"
systemctl enable shipping
systemctl restart shipping

echo -e "\e[35m>>>>>>>>>> Install MySQL Servere <<<<<<<<<<\e[0m"
dnf install mysql -y