# Teamcity

# Installation

Для начала нужно добавить в файл terraform/{окружение}/terraform.tfvars 
переменные 
- aws_access_key  = "gasfdfasdf"
- aws_secret_key  = "asdfasdfasdfadsfwaerewrwerewr"
- rds_db_username = "rds_db_username"
- rds_db_password = "rds_db_password"

Далее можно пременить
```sh
cd prod
terraform apply
```
 
```sh
mkdir ~/.kube/
terraform output kubeconfig>~/.kube/config
```

```sh
cd ../k8s
kubectl create -f  teamcity-agent-rc.yml
kubectl create -f  teamcity-rc.yml
kubectl create -f  teamcity-service.yml
```
Получаем опубликованный в load balancer адрес
```sh
kubectl get service/teamcity
```

Заходим и настраиваем подключение к бд.