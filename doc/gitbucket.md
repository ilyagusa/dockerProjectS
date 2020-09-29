# Описание Dockerfile для Gitbucket
Данный файл брался c оффициального git репозитория проекта gitbucket

Образ базируется на  openjdk:8-jre
```
FROM openjdk:8-jre
```
Добавление приложения gitbucket.war
```
ADD https://github.com/gitbucket/gitbucket/releases/download/4.34.0/gitbucket.war /opt/gitbucket.war
```
Создание символической ссылки на директорию /gitbucket
```
RUN ln -s /gitbucket /root/.gitbucket
```
Создание хранилища с базами данных и конфигурационными файлами приложения
```
VOLUME /gitbucket
```
Открытие поротов
```
EXPOSE 3000 29418
```
Задание первоначальной команды
```
CMD ["sh", "-c", "java -jar /opt/gitbucket.war"]
```
