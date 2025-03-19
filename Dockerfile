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

# Финальный минимальный образ с JRE 21
FROM eclipse-temurin:21-jre

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем зависимости для Chrome
RUN apt-get update -y && apt-get install -y \
    wget \
    curl \
    unzip \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    fonts-liberation \
    libgbm1 \
    libxshmfence1 \
    libdouble-conversion3 \
    libminizip1

# Устанавливаем Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install \
    && rm google-chrome-stable_current_amd64.deb

# Устанавливаем ChromeDriver (версию под Chrome)
RUN wget -q https://chromedriver.storage.googleapis.com/134.0.6342.0/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip

# Проверяем реальное имя JAR-файла
COPY --from=builder /app/target/google-search-cli-1.0-SNAPSHOT.jar ./google-search-cli.jar

# Указываем переменные среды для Chrome и ChromeDriver
ENV PATH="/usr/bin:${PATH}"

# Указываем команду запуска при старте контейнера
ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
