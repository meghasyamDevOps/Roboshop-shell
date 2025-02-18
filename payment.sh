echo -e "\e[35m>>>>>>>>>> Install Python 3 <<<<<<<<<<\e[0m"
dnf install python3 gcc python3-devel -y

echo -e "\e[35m>>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[35m>>>>>>>>>> Copy Service File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[35m>>>>>>>>>> Setup an app directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[35m>>>>>>>>>> Download the application code <<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip
cd /app
unzip /tmp/payment.zip

echo -e "\e[35m>>>>>>>>>> Download the dependencies <<<<<<<<<<\e[0m"
cd /app
pip3 install -r requirements.txt

echo -e "\e[35m>>>>>>>>>> Load the service <<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[35m>>>>>>>>>> Start the service <<<<<<<<<<\e[0m"
systemctl enable payment
systemctl start payment