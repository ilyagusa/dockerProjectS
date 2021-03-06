# Описание Dockerfile для Jenkins
Данный Dockerfile основан на openjdk:8-jdk-alpine т.к Jenkins написан на Java
```
FROM openjdk:8-jdk-alpine
```
Установка зависимостей
```
RUN apk add --no-cache \
  bash \
  coreutils \
  curl \
  git \
  git-lfs \
  openssh-client \
  tini \
  ttf-dejavu \
  tzdata \
  unzip
```
Задание аргументов и переменных окружения
```
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=/usr/share/jenkins/ref
ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT $agent_port
ENV REF $REF
ARG JENKINS_VERSION
ENV JENKINS_VERSION $(JENKINS_VERSION:-2.235)
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/JENKINS_VERSION/jenkins-war-JENKINS_VERSION.war
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV COPY_REFERENCE_FILE_LOG JENKINS_HOME/copy_reference_file.log
```
Создание корневого каталога , добавление группы и пользователя, а также изменение владельца корневого каталога
```
RUN mkdir -p JENKINS_HOME \
   chown uid:gid JENKINS_HOME \
   addgroup -g gid group \
   adduser -h "JENKINS_HOME" -u uid -G group -s /bin/bash -D user
```
Скачивание исполняемого файла jenkins.war
```
RUN curl -fsSL JENKINS_URL -o /usr/share/jenkins/jenkins.war \
   echo "JENKINS_SHA  /usr/share/jenkins/jenkins.war"
```
Открытие портов
```
#for main web interface:
EXPOSE http_port
#will be used by attached slave agents:
EXPOSE agent_port
```
Добавление скриптов необходимых для запуска приложения
```
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY tini-shim.sh /bin/tini
```
Указание входной точки
```
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY tini-shim.sh /bin/tini
```
Добавление скриптов для плагинов
```
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
```
Указание хранилища
```
VOLUME /var/jenkins_home
```
Добавление языка руби для проверки интеграции gitbucket и jenkins(запуск приложения ruby из git-репозитория)
```
RUN apk add ruby-full
```
