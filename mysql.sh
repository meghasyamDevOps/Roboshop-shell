script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input MySQL Root password missing
  exit 1
fi

print_head "Install MySQL Server"
dnf install mysql-server -y &>>$log_file
func_status_check $?

print_head "Start MySQL Service"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_status_check $?

print_head "Change the default root password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_status_check $?