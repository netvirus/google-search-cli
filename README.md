📌 Как использовать Dockerfile?

🔹 1. Собрать образ
        docker build -t google-search .
🔹 2. Запустить контейнер и выполнить поиск
        docker run --rm google-search "купить ноутбук" --limit 5
🔹 3. Запустить контейнер в интерактивном режиме
        docker run --rm -it google-search /bin/sh

📌 Что делает этот Dockerfile?

Использует eclipse-temurin:21-jdk для сборки проекта.

Кеширует зависимости Maven (mvn dependency:go-offline).

Копирует исходный код и собирает JAR.

Финальный образ использует eclipse-temurin:21-jre (без JDK, для меньшего размера).

Автоматически запускает Java-приложение с передачей аргументов.