# Используем образ с Chrome и ChromeDriver нужной версии
FROM selenium/standalone-chrome:134.0 AS chrome_base

# Используем образ с JDK 21 и Maven для сборки
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Финальный минимальный образ на основе Chrome
FROM chrome_base

# Устанавливаем пользователя root для установки зависимостей
USER 0

WORKDIR /app

# Устанавливаем дополнительные зависимости
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    wget \
    curl \
    unzip \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Указываем точную версию ChromeDriver
ENV CHROMEDRIVER_VERSION=134.0.6998.88

# Скачиваем и устанавливаем ChromeDriver вручную
RUN wget -q "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip

# Возвращаемся обратно к пользователю seluser
USER seluser

# Копируем JAR-файл из builder-образа
COPY --from=builder /app/target/google-search-cli-1.0-SNAPSHOT.jar ./google-search-cli.jar

# Указываем команду запуска
ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
