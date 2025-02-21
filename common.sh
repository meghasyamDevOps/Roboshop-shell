app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
#rm -rf /tmp
log_file=/tmp/roboshop.log

print_head() {
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<\e[0m" &>>$log_file
}

func_app_user(){
  id ${app_user}
  if [ $? -ne 0 ]; then
      useradd ${app_user}
  fi
}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo -e "\e[36mFor more information reach out to log file /tmp/roboshop.log\e[0m"
    exit 1
  fi
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
      print_head "Copy Mongo Repo File"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
      func_status_check $?

      print_head "Insatll mongodb Client"
      dnf install mongodb-mongosh -y &>>$log_file
      func_status_check $?

      print_head "Load schema"
      mongosh --host mongodb-dev.meghadevops.site </app/db/master-data.js &>>$log_file
      func_status_check $?

      print_head "Restart ${component}"
      systemctl restart ${component} &>>$log_file
      func_status_check $?
  fi

  if [ "$schema_setup" == "mysql" ]; then
      print_head "Install MySQL Server"
      dnf install mysql -y &>>$log_file
      func_status_check $?

      print_head "Load Schema"
      mysql -h mysql-dev.meghadevops.site -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
      func_status_check $?

      print_head "Create app user"
      mysql -h mysql-dev.meghadevops.site -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
      func_status_check $?

      print_head "Load Master Data"
      mysql -h mysql-dev.meghadevops.site -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
      func_status_check $?

      print_head "Restart the service"
      systemctl restart ${component} &>>$log_file
      func_status_check $?
  fi
}

func_app_prereq() {
  print_head "Add application User"
  func_app_user &>>$log_file
  func_status_check $?

  print_head "Copy user service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status_check $?

  print_head "setup an app directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_status_check $?

  print_head "Download the application code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$log_file
  cd /app &>>$log_file
  unzip /tmp/${component}.zip &>>$log_file
  func_status_check $?
}

func_load_service(){
  print_head "Load the service"
  systemctl daemon-reload &>>$log_file
  func_status_check $?

  print_head "Restart the service"
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_status_check $?
}

func_nodejs() {
    print_head "Disable the version"
    dnf module disable nodejs -y &>>$log_file
    func_status_check $?

    print_head "Enable the version"
    dnf module enable nodejs:20 -y &>>$log_file
    func_status_check $?

    print_head "Install NodeJS"
    dnf install nodejs -y &>>$log_file
    func_status_check $?

    func_app_prereq

    print_head "Download the Dependencies"
    cd /app &>>$log_file
    npm install &>>$log_file
    func_status_check $?

    func_load_service

    func_schema_setup
}

func_golang() {
  print_head "Install GoLang"
  dnf install golang -y &>>$log_file
  func_status_check $?

  func_app_prereq

  print_head "download the dependencies"
  cd /app &>>$log_file
  go mod init dispatch &>>$log_file
  go get &>>$log_file
  go build &>>$log_file
  func_status_check $?

  func_load_service
}

func_nginx() {
  print_head "Disable Nginx"
  dnf module disable nginx -y &>>$log_file
  func_status_check $?

  print_head "Enable Nginx"
  dnf module enable nginx:1.24 -y &>>$log_file
  func_status_check $?

  print_head "Install Nginx"
  dnf install nginx -y &>>$log_file
  func_status_check $?

  print_head "Start & Enable Nginx service"
  systemctl enable nginx &>>$log_file
  systemctl start nginx &>>$log_file
  func_status_check $?

  print_head "Copy the service File"
  cp ${script_path}/nginx.conf /etc/nginx/nginx.conf &>>$log_file
  func_status_check $?

  print_head "Remove the default content"
  rm -rf /usr/share/nginx/html/* &>>$log_file
  func_status_check $?

  print_head "Download the frontend content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$log_file
  func_status_check $?

  print_head "Extract the frontend content"
  cd /usr/share/nginx/html &>>$log_file
  unzip /tmp/${component}.zip &>>$log_file
  func_status_check $?

  print_head "Restart Nginx Service"
  systemctl restart nginx &>>$log_file
}

func_python() {
  print_head "Install Python"
  dnf install python3 gcc python3-devel -y &>>$log_file
  func_status_check $?

  func_app_prereq

  print_head "Download the dependencies"
  cd /app &>>$log_file
  pip3 install -r requirements.txt &>>$log_file
  func_status_check $?

  func_load_service
}

func_java() {
  print_head "Install Maven"
  dnf install maven -y &>>$log_file
  func_status_check $?

  func_app_prereq

  print_head "Download the dependencies"
  cd /app
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_status_check $?

  func_load_service

  func_schema_setup
}

func_mongodb() {
  print_head "Copy Mongo Repo File"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
  func_status_check $?

  print_head "Install MonogoDB"
  dnf install mongodb-org -y &>>$log_file
  func_status_check $?

  print_head "Enable Mongodb"
  systemctl enable mongod &>>$log_file
  systemctl start mongod &>>$log_file
  func_status_check $?

  print_head "Chage the mongodb Listen Address"
  sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
  func_status_check $?

  print_head "Restart Mongodb"
  systemctl restart mongod &>>$log_file
  func_status_check $?
}