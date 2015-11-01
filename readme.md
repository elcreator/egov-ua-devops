Альтернативный установщик пакетов e-government-ua. Может помочь, если не заработал оригинальный.

* Скачиваем Ubuntu 14.04 http://releases.ubuntu.com/14.04/ubuntu-14.04.3-server-amd64.iso

* Скачиваем бесплатную версию VMWare Player 7 http://downloads.tomsguide.com/VMWare-Player,0301-3519.html

* Устанавливаем Ubuntu в VMWare Player, ставим свой пароль на root, смотрим назначенный виртуалке IP.
  Создаем папку /project

* Для пользователей Intellij IDEA (для Backend): качаем плагин https://plugins.jetbrains.com/plugin/7374?pr=idea
  Для пользоватей WebStorm (для Frontend): https://www.jetbrains.com/webstorm/help/deployment.html
  В IDE указываем плагину для деплоймента IP и логин/пароль виртуалки, удаленную папку /project, локальную папку
  ту, куда клонировали репозиторий e-government-ua. Деплоим.

* Качаем скрипт из данного репозитория /ubuntu/package-installer.sh и запускаем его - пакеты установятся.
  Дальше настраиваем по инструкциям на основном репозитории.
