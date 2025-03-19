package com.google.search;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

public class GoogleSearchService {
    public void performSearch(String query, int limit, int timeout) {
        WebDriver driver = BrowserManager.getDriver();
        driver.get("https://www.google.com/search?q=" + query);

        List<WebElement> results = driver.findElements(By.cssSelector("h3"));
        for (int i = 0; i < Math.min(results.size(), limit); i++) {
            System.out.println((i + 1) + ". " + results.get(i).getText());
        }

        BrowserManager.quitDriver();
    }
}
