# Используем образ с JDK 21 и Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем POM-файл и загружаем зависимости
COPY pom.xml .
RUN mvn dependency:go-offline

# Копируем исходный код проекта
COPY src ./src

# Собираем проект (генерируем fat JAR с учетом плагинов)
RUN mvn clean package -DskipTests

# Проверяем, какой JAR-файл был сгенерирован
RUN ls -l target

# Финальный минимальный образ с JRE 21
FROM eclipse-temurin:21-jre

# Устанавливаем рабочую директорию
WORKDIR /app

# Проверяем реальное имя JAR-файла
COPY --from=builder /app/target/*.jar ./google-search-cli.jar

# Указываем команду запуска при старте контейнера
ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
