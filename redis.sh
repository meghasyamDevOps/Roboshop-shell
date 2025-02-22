script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "Disable previous version redis"
dnf module disable redis -y &>>$log_file
func_status_check $?

print_head "Enable redis"
dnf module enable redis:7 -y &>>$log_file
func_status_check $?

print_head "Install redis"
dnf install redis -y &>>$log_file
func_status_check $?

print_head "Update listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf &>>$log_file
sed -i -e 's|protected-mode yes|protected-mode no|' /etc/redis/redis.conf &>>$log_file
func_status_check $?

print_head "Enable & Restart redis"
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
func_status_check $?
