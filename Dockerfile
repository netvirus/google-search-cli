# Используем образ с JDK 21 и Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем pom.xml и загружаем зависимости
COPY pom.xml .
RUN mvn dependency:go-offline

# Копируем весь исходный код проекта
COPY src ./src

# Собираем проект
RUN mvn clean package -DskipTests

# Финальный минимальный образ с JRE 21
FROM eclipse-temurin:21-jre

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скомпилированный JAR-файл из предыдущего этапа
COPY --from=builder /app/target/google-search-cli.jar ./google-search-cli.jar

# Указываем команду запуска при старте контейнера
ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
