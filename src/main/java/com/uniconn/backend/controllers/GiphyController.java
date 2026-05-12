package com.uniconn.backend.controllers;

import com.uniconn.backend.services.GiphyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/giphy")
public class GiphyController {

    @Autowired
    private GiphyService giphyService;

    @GetMapping("/search")
    public ResponseEntity<String> searchGifs(
            @RequestParam String q,
            @RequestParam(defaultValue = "40") int limit) {

        String result = giphyService.searchGifs(q, limit);
        return ResponseEntity.ok(result);
    }
}
