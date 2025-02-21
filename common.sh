app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<\e[0m"
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
      print_head "Copy Mongo Repo File"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

      print_head "Insatll mongodb Client"
      dnf install mongodb-mongosh -y

      print_head "Load schema"
      mongosh --host mongodb-dev.meghadevops.site </app/db/master-data.js

      print_head "Restart catalogue"
      systemctl restart ${component}
  fi

  if [ "$schema_setup" == "mysql" ]; then
      print_head "Install MySQL Server"
      dnf install mysql -y

      print_head "Load Schema"
      mysql -h mysql-dev.meghadevops.site -uroot -pRoboShop@1 < /app/db/schema.sql

      print_head "Create app user"
      mysql -h mysql-dev.meghadevops.site -uroot -pRoboShop@1 < /app/db/app-user.sql

      print_head "Load Master Data"
      mysql -h mysql-dev.meghadevops.site -uroot -pRoboShop@1 < /app/db/master-data.sql

      print_head "Restart the service"
      systemctl restart ${component}
  fi
}

func_app_prereq() {
  print_head "Add application User"
  id ${app_user}
  if [ $? -ne 0 ]; then
      useradd ${app_user}
  fi

  print_head "Copy user service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "setup an app directory"
  rm -rf /app
  mkdir /app

  print_head "Download the application code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  cd /app
  unzip /tmp/${component}.zip
}

func_load_service(){
  print_head "Load the service"
  systemctl daemon-reload

  print_head "Restart the service"
  systemctl enable ${component}
  systemctl restart ${component}
}

func_nodejs() {
    print_head "Enable 20 version and install list"
    dnf module disable nodejs -y
    dnf module enable nodejs:20 -y

    print_head "Install NodeJS"
    dnf install nodejs -y

    func_app_prereq

    print_head "Download the Dependencies"
    cd /app
    npm install

    func_load_service

    func_schema_setup
}

func_golang() {
  print_head "Install GoLang"
  dnf install golang -y

  func_app_prereq

  print_head "download the dependencies"
  cd /app
  go mod init dispatch
  go get
  go build

  func_load_service
}

func_nginx() {
  print_head "Install Nginx"
  dnf module disable nginx -y
  dnf module enable nginx:1.24 -y
  dnf install nginx -y

  print_head "Start & Enable Nginx service"
  systemctl enable nginx
  systemctl start nginx

  print_head "Copy the service File"
  cp ${script_path}/nginx.conf /etc/nginx/nginx.conf

  print_head "Remove the default content"
  rm -rf /usr/share/nginx/html/*

  print_head "Download the frontend content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip

  print_head "Extract the frontend content"
  cd /usr/share/nginx/html
  unzip /tmp/${component}.zip

  print_head "Restart Nginx Service"
  systemctl restart nginx
}

func_python() {
  print_head "Install Python"
  dnf install python3 gcc python3-devel -y

  func_app_prereq

  print_head "Download the dependencies"
  cd /app
  pip3 install -r requirements.txt

  func_load_service
}

func_java() {
  print_head "Install Maven"
  dnf install maven -y

  func_app_prereq

  print_head "Download the dependencies"
  cd /app
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_load_service

  func_schema_setup
}