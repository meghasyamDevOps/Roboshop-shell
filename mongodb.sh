echo -e "\e[36m>>>>>>>>>> Copy Mongo Repo File <<<<<<<<<<\e[0m"
cp /home/ec-2user/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Install MonogoDB <<<<<<<<<<\e[0m"
dnf install mongodb-org -y

echo -e "\e[36m>>>>>>>>>> Enable Mongodb <<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl start mongod

echo -e "\e[36m>>>>>>>>>> Chage the mongodb Listen Address <<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>>> Restart Mongodb <<<<<<<<<<\e[0m"
systemctl restart mongod