# Используем базовый образ с Chrome и ChromeDriver
FROM selenium/standalone-chrome:latest AS chrome_base

# Используем образ с JDK 21 и Maven для сборки
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Финальный минимальный образ на основе selenium/standalone-chrome
FROM chrome_base

WORKDIR /app

# Устанавливаем дополнительные зависимости, если нужны
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    wget \
    curl \
    unzip \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Копируем JAR-файл из builder-образа
COPY --from=builder /app/target/google-search-cli-1.0-SNAPSHOT.jar ./google-search-cli.jar

# Устанавливаем переменные среды для Chrome и ChromeDriver
ENV PATH="/usr/bin:${PATH}"

ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
