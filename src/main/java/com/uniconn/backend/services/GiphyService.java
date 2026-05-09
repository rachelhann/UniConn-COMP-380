package com.uniconn.backend.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class GiphyService {

    @Value("${giphy.api.key}")
    private String apiKey;

    private static final String GIPHY_SEARCH_URL = "https://api.giphy.com/v1/gifs/search";
    private final RestTemplate restTemplate = new RestTemplate();

    public String searchGifs(String query, int limit) {
        String url = UriComponentsBuilder.fromHttpUrl(GIPHY_SEARCH_URL)
                .queryParam("api_key", apiKey)
                .queryParam("q", query)
                .queryParam("limit", limit)
                .queryParam("rating", "g")
                .toUriString();

        return restTemplate.getForObject(url, String.class);
    }
}
