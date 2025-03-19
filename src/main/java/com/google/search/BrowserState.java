package com.google.search;

import java.util.Map;

public class BrowserState {
    private Map<String, String> cookies;
    private String userAgent;

    public BrowserState() {}

    public BrowserState(Map<String, String> cookies, String userAgent) {
        this.cookies = cookies;
        this.userAgent = userAgent;
    }

    public Map<String, String> getCookies() {
        return cookies;
    }

    public void setCookies(Map<String, String> cookies) {
        this.cookies = cookies;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
}
