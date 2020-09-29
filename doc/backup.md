# Описание запуска скрипта для резервного копирования
Скрипт находится в папке backup
Для работы скрипта необходимо указать параметры(путь к главной директории проекта, путь к tar-архиву, а также метод использования(zip/unzip):
* `--pathdir` - путь до главной директории проекта, можно вводить как относительный, так и абсолютный путь.
* `--pathback` - путь до директории , в которой находится/будет находится tar-архив(аналогично можно использовать относительный/полный путь)
* `--mehod` - метод использования скрипта
	- `zip` используется , чтобы создать архив с файлами бэкапа.
	- `unzip` используется, чтобы распаковать архив и заменить текущие базы данных приложений.

При указании пути, указывается только путь до директории в которой должен лежать архив.
Если нужно создать архив `/var/tmp/back.tar` то следует ввести в пути `/var/tmp` , а имя архива нужно будет указать после проверки существования введенного вами пути,
о чем вас оповестит программа.
