script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue

func_nodejs

echo -e "\e[36m>>>>>>>>>> Copy Mongo Repo File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Insatll mongodb Client <<<<<<<<<<\e[0m"
dnf install mongodb-mongosh -y

echo -e "\e[36m>>>>>>>>>> Load schema <<<<<<<<<<\e[0m"
mongosh --host mongodb-dev.meghadevops.site </app/schema/catalogue.js

echo -e "\e[36m>>>>>>>>>> Restart catalogue <<<<<<<<<<\e[0m"
systemctl restart catalogue