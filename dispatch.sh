echo -e "\e[35m>>>>>>>>>> Install GoLang <<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[35m>>>>>>>>>> Add application User <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[35m>>>>>>>>>> Copy the service File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[35m>>>>>>>>>> Setup an app directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[35m>>>>>>>>>> Download the application code <<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[35m>>>>>>>>>> download the dependencies  <<<<<<<<<<\e[0m"
cd /app
go mod init dispatch
go get
go build

echo -e "\e[35m>>>>>>>>>> Load the service <<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[35m>>>>>>>>>> Start the service <<<<<<<<<<\e[0m"
systemctl enable dispatch
systemctl start dispatch