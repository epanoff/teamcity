# Teamcity

# Installation

Для начала нужно добавить в файл terraform/{окружение}/terraform.tfvars 
переменные 
- aws_access_key  = "gasfdfasdf"
- aws_secret_key  = "asdfasdfasdfadsfwaerewrwerewr"
- rds_db_username = "rds_db_username"
- rds_db_password = "rds_db_password"

Прописать в 

Так же потребуется поставить
```sh
brew install aws-iam-authenticator
```

Далее можно пременить (на примере прода)
```sh
cd prod
terraform apply
```

В выводе он выдаст параметры подключения к бд и конфиг для подключения к кубернетису
```sh
mkdir ~/.kube/
terraform output kubeconfig>~/.kube/config
```

И запускаем, тимсити с persistent volume и тремя агентами. 
```sh
cd ../../k8s
kubectl create -f teamcity-agent.yml
kubectl create -f volume.yml
kubectl create -f teamcity.yml
kubectl create -f teamcity-service.yml
```
Получаем опубликованный в load balancer адрес
```sh
kubectl get service/teamcity
```

Заходим и настраиваем подключение к бд, которую создали при помощи терреформ. 