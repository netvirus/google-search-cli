package com.google.search;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class BrowserManager {
    private static WebDriver driver;

    public static WebDriver getDriver() {
        if (driver == null) {
            // Устанавливаем ChromeDriver, если он не установлен
            WebDriverManager.chromedriver().setup();

            // Создаём объект настроек Chrome
            ChromeOptions options = new ChromeOptions();
            options.addArguments("--headless"); // Запуск в headless-режиме (обязательно для Docker)
            options.addArguments("--no-sandbox"); // Отключаем sandbox для запуска в контейнере
            options.addArguments("--disable-dev-shm-usage"); // Используем shared memory
            options.addArguments("--disable-gpu"); // Отключаем GPU, так как он не нужен в headless-режиме
            options.addArguments("--remote-allow-origins=*"); // Разрешаем удалённые соединения
            options.addArguments("--disable-software-rasterizer"); // Отключаем software рендеринг
            options.addArguments("--window-size=1920,1080"); // Устанавливаем размер окна браузера

            driver = new ChromeDriver(options);
        }
        return driver;
    }

    public static void quitDriver() {
        if (driver != null) {
            driver.quit();
            driver = null;
        }
    }
}
