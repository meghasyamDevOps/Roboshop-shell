script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input RabbitMQ App User password missing
  exit 1
fi

print_head "Copy Repo File"
cp ${script_path}/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
func_status_check $?

print_head "Install RabbitMQ Server"
dnf install rabbitmq-server -y &>>$log_file
func_status_check $?

print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_status_check $?

print_head "Create one user for the application"
rabbitmqctl add_user roboshop $rabbitmq_appuser_password &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_status_check $?