package com.uniconn.backend.services;

import com.uniconn.backend.dtos.SearchResultDTO;
import com.uniconn.backend.repositories.SearchRepository;
import org.springframework.stereotype.Service;
import java.util.stream.Collectors;

@Service
public class SearchService {

    private final SearchRepository searchRepository;

    public SearchService(SearchRepository searchRepository) {
        this.searchRepository = searchRepository;
    }

    public SearchResultDTO search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new RuntimeException("Search keyword cannot be empty");
        }

        String trimmed = keyword.trim();

        return new SearchResultDTO(
            searchRepository.searchUsers(trimmed).stream()
                .map(SearchResultDTO.UserResult::new)
                .collect(Collectors.toList()),
            searchRepository.searchCommunities(trimmed).stream()
                .map(SearchResultDTO.CommunityResult::new)
                .collect(Collectors.toList()),
            searchRepository.searchPosts(trimmed).stream()
                .map(SearchResultDTO.PostResult::new)
                .collect(Collectors.toList())
        );
    }
}