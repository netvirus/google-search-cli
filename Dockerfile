# Билдер с JDK 21 и Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Финальный минимальный образ с JRE 21
FROM eclipse-temurin:21-jre

WORKDIR /app

# Устанавливаем зависимости
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    wget unzip ca-certificates curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Скачиваем Chrome for Testing
ENV CHROME_VERSION=134.0.6998.88
RUN wget -q "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip" \
    && unzip chrome-linux64.zip \
    && mv chrome-linux64 /opt/chrome \
    && ln -s /opt/chrome/chrome /usr/bin/google-chrome \
    && rm chrome-linux64.zip

# Скачиваем ChromeDriver для Testing
RUN wget -q "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip" \
    && unzip chromedriver-linux64.zip \
    && mv chromedriver-linux64/chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm -rf chromedriver-linux64*

# Копируем собранный JAR
COPY --from=builder /app/target/google-search-cli-1.0-SNAPSHOT.jar ./google-search-cli.jar

ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
