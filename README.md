# Teamcity

# Installation

Для начала нужно добавить в файл terraform/{окружение}/terraform.tfvars 
переменные 
- aws_access_key  = "gasfdfasdf"
- aws_secret_key  = "asdfasdfasdfadsfwaerewrwerewr"
- rds_db_username = "rds_db_username"
- rds_db_password = "rds_db_password"

Необходимо иметь загруженный ssl сертификат в AWS Certificate Manager. Его arn требуется поставить в teamcity-service.yml

Так же потребуется поставить
```sh
brew install aws-iam-authenticator
```
Проставить нужные переменные в main.tf (типы инстенса и тп)
Далее можно пременить (на примере прода)
```sh
cd prod
terraform apply -auto-approve
```

В выводе он выдаст параметры подключения к бд и конфиг для подключения к кубернетису
```sh
mkdir ~/.kube/
terraform output kubeconfig>~/.kube/config
```

И тимсити с persistent volume, тремя агентами опубликованные через loadbalancer с сертификатом. 
```sh
cd ../../k8s
kubectl create -f cluster-autoscaler-autodiscover.yaml
kubectl create -f teamcity-agent.yml
kubectl create -f volume.yml
kubectl create -f teamcity.yml
kubectl create -f teamcity-service.yml
```
Получаем опубликованный в load balancer адрес
```sh
kubectl get service/teamcity
```

Заходим и настраиваем подключение к бд, параметры подключения к которой выдал терреформ. 

При необходимости увеличения количества агентов
```sh
kubectl scale deployment teamcity-agent --replicas=30
```
Автоскейлинг подберет нужно количество агентов. [Подробнее про автоскейлер](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html)
Перед уничтожением нужно удалить созданный сервис, так как он создает nlb не явный для терраформа.
```sh
kubectl delete service/teamcity
```

