package com.uniconn.backend.services;

import com.uniconn.backend.dtos.SearchResultDTO;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.repositories.SearchRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SearchService extends BaseService {

    private final SearchRepository searchRepository;

    public SearchService(SearchRepository searchRepository) {
        this.searchRepository = searchRepository;
    }

    // --- General Search ---
    public SearchResultDTO search(String keyword) {
        validateKeyword(keyword);
        String trimmed = keyword.trim();
        return new SearchResultDTO(
                mapToUserResults(searchRepository.searchUsers(trimmed)),
                mapToCommunityResults(searchRepository.searchCommunities(trimmed)),
                mapToPostResults(searchRepository.searchPosts(trimmed))
        );
    }

    // --- Explore Communities Search ---
    public List<SearchResultDTO.CommunityResult> searchCommunitiesForExplore(String keyword) {
        validateKeyword(keyword);
        return mapToCommunityResults(
                searchRepository.searchCommunitiesForExplore(keyword.trim())
        );
    }

    // --- My Communities Search ---
    public List<SearchResultDTO.CommunityResult> searchMyCommunities(String keyword) {
        validateKeyword(keyword);
        User currentUser = getAuthenticatedUser();
        return mapToCommunityResults(
                searchRepository.searchUserCommunities(currentUser.getUserId(), keyword.trim())
        );
    }

    // --- Following Search ---                                                                 ///temp for testing
    public List<SearchResultDTO.UserResult> searchFollowing(String keyword) {
        validateKeyword(keyword);
        // TEMP: hardcoded user ID 1 (alex_m92) for local testing only
        return mapToUserResults(
                searchRepository.searchFollowing(1, keyword.trim())
        );
    }

    // --- Followers Search ---                                                                 //temp for testing
    public List<SearchResultDTO.UserResult> searchFollowers(String keyword) {
        validateKeyword(keyword);
        // TEMP: hardcoded user ID 1 (alex_m92) for local testing only
        return mapToUserResults(
                searchRepository.searchFollowers(1, keyword.trim())
        );
    }

    // --- Community Members Search ---
    public List<SearchResultDTO.UserResult> searchCommunityMembers(Integer communityId, String keyword) {
        validateKeyword(keyword);
        return mapToUserResults(
                searchRepository.searchCommunityMembers(communityId, keyword.trim())
        );
    }

        // --- Tag Search ---
    public List<SearchResultDTO.TagResult> searchTags(String keyword) {
        validateKeyword(keyword);
        return searchRepository.searchTags(keyword.trim())
                .stream()
                .map(SearchResultDTO.TagResult::new)
                .collect(Collectors.toList());
    }

    // --- Communities by Tag ---
    public List<SearchResultDTO.CommunityResult> searchCommunitiesByTag(String keyword) {
        validateKeyword(keyword);
        return mapToCommunityResults(
                searchRepository.searchCommunitiesByTag(keyword.trim())
        );
    }

    // --- Posts by Tag ---
    public List<SearchResultDTO.PostResult> searchPostsByTag(String keyword) {
        validateKeyword(keyword);
        return mapToPostResults(
                searchRepository.searchPostsByTag(keyword.trim())
        );
    }

    // --- Private Helpers ---
    private void validateKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be empty");
        }
    }

    private List<SearchResultDTO.UserResult> mapToUserResults(List<com.uniconn.backend.entities.User> users) {
        return users.stream()
                .map(SearchResultDTO.UserResult::new)
                .collect(Collectors.toList());
    }

    private List<SearchResultDTO.CommunityResult> mapToCommunityResults(List<com.uniconn.backend.entities.Community> communities) {
        return communities.stream()
                .map(SearchResultDTO.CommunityResult::new)
                .collect(Collectors.toList());
    }

    private List<SearchResultDTO.PostResult> mapToPostResults(List<com.uniconn.backend.entities.Post> posts) {
        return posts.stream()
                .map(SearchResultDTO.PostResult::new)
                .collect(Collectors.toList());
    }
}