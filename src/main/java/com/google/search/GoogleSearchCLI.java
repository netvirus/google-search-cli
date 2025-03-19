package com.google.search;

import picocli.CommandLine;
import java.util.concurrent.Callable;

@CommandLine.Command(name = "google-search", mixinStandardHelpOptions = true,
        description = "Google search CLI tool using Selenium")
public class GoogleSearchCLI implements Callable<Integer> {

    @CommandLine.Parameters(index = "0", description = "Search query")
    private String query;

    @CommandLine.Option(names = {"-l", "--limit"}, description = "Limit search results", defaultValue = "10")
    private int limit;

    @CommandLine.Option(names = {"-t", "--timeout"}, description = "Timeout (ms)", defaultValue = "30000")
    private int timeout;

    @Override
    public Integer call() {
        GoogleSearchService searchService = new GoogleSearchService();
        searchService.performSearch(query, limit, timeout);
        return 0;
    }

    public static void main(String[] args) {
        int exitCode = new CommandLine(new GoogleSearchCLI()).execute(args);
        System.exit(exitCode);
    }
}
