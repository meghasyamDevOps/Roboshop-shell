echo -e "\e[35m>>>>>>>>>> Install MySQL Servere <<<<<<<<<<\e[0m"
dnf install mysql-server -y

echo -e "\e[35m>>>>>>>>>> Start MySQL Service <<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[35m>>>>>>>>>> Change the default root password <<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1