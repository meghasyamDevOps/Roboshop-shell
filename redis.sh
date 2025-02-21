echo -e "\e[36m>>>>>>>>>> Install redis <<<<<<<<<<\e[0m"
dnf module disable redis -y
dnf module enable redis:7 -y

echo -e "\e[36m>>>>>>>>>> Download the dependencies <<<<<<<<<<\e[0m"
dnf install redis -y

echo -e "\e[36m>>>>>>>>>> Update listen address <<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf
sed -i -e 's|protected-mode yes|protected-mode no|' /etc/redis/redis.conf

echo -e "\e[36m>>>>>>>>>> download the dependencies <<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis
