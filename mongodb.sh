script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "Copy Mongo Repo File"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

print_head "Install MonogoDB"
dnf install mongodb-org -y &>>$log_file
func_status_check $?

print_head "Enable & Start Mongodb"
systemctl enable mongod &>>$log_file
systemctl start mongod &>>$log_file
func_status_check $?

print_head "Chage the mongodb Listen Address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?

print_head "Restart Mongodb"
systemctl restart mongod &>>$log_file
func_status_check $?