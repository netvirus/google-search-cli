package com.google.search;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;

public class StateManager {
    private static final String STATE_FILE = "browser-state.json";

    public static void saveState(BrowserState state) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            mapper.writeValue(new File(STATE_FILE), state);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static BrowserState loadState() {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readValue(new File(STATE_FILE), BrowserState.class);
        } catch (IOException e) {
            return new BrowserState();
        }
    }
}
