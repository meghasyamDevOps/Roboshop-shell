app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>>>> $1 <<<<<<<<<<\e[0m"
}

func_nodejs() {
    print_head "Enable 20 version and install list"
    dnf module disable nodejs -y
    dnf module enable nodejs:20 -y

    print_head "Install NodeJS"
    dnf install nodejs -y

    print_head "Add application User"
    useradd ${app_user}

    print_head "Copy user service file"
    cp /home/ec2-user/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service

    print_head "setup an app directory"
    rm -rf /app
    mkdir /app

    print_head "Download the application code"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
    cd /app
    unzip /tmp/${component}.zip

    print_head "Download the Dependencies"
    cd /app
    npm install

    print_head "Load the service"
    systemctl daemon-reload

    print_head "Restart the service"
    systemctl enable ${component}
    systemctl restart ${component}
}