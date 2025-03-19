# Используем официальный образ JDK 21
FROM eclipse-temurin:21-jdk as builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файл сборки Maven (pom.xml) и зависимости
COPY pom.xml .

# Загружаем зависимости
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline

# Копируем исходный код проекта
COPY src ./src

# Собираем проект
RUN mvn clean package -DskipTests

# Создаём финальный минимизированный образ
FROM eclipse-temurin:21-jre

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скомпилированный JAR-файл из предыдущего этапа
COPY --from=builder /app/target/google-search-cli.jar ./google-search-cli.jar

# Указываем команду запуска при старте контейнера
ENTRYPOINT ["java", "-jar", "google-search-cli.jar"]
