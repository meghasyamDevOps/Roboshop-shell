echo -e "\e[35m>>>>>>>>>> Copy Repo File <<<<<<<<<<\e[0m"
cp /home/ec2-user/Roboshop-shell/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

echo -e "\e[35m>>>>>>>>>> Install RabbitMQ Server <<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[35m>>>>>>>>>> Start RabbitMQ Service <<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[35m>>>>>>>>>> Create one user for the application <<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"