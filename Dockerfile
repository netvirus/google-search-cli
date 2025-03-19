# Билдер с JDK 21 и Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Используем Selenium Standalone Chrome с нужной версией Chrome и ChromeDriver
FROM selenium/standalone-chrome:114.0  # Выбираем версию с поддержкой CDP 131

WORKDIR /app

# Копируем собранный JAR из билдера
COPY --from=builder /app/target/google-search-cli-1.0-SNAPSHOT.jar ./google-search-cli.jar

ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
