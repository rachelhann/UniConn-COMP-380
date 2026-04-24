package com.uniconn.backend.services;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.repositories.CommunityTagRepository;
import jakarta.transaction.Transactional;

@Service
public class CommunityTagService {
	private final CommunityTagRepository communityTagRepository;
	private final TagService tagService;
	
	public CommunityTagService(CommunityTagRepository communityTagRepository, TagService tagService) {
		this.communityTagRepository = communityTagRepository;
		this.tagService = tagService;
	}
	
	@Transactional
	public List<String> saveTags(Community community, List<String> rawTags) {
	    if (rawTags == null || rawTags.isEmpty()) return List.of();

	    List<String> limited = rawTags.stream().limit(5).toList();
	    List<String> savedNames = new ArrayList<>();

	    for (String raw : limited) {
	        Tag tag = tagService.findOrCreate(raw);
	        communityTagRepository.save(new CommunityTag(community, tag));
	        savedNames.add(tag.getName());
	    }

	    return savedNames;
	}
	
	@Transactional
	public void updateTags(Community community, List<String> newRawTags) {
		communityTagRepository.deleteByCommunity_CommunityId(community.getCommunityId());
		saveTags(community, newRawTags);
	}

}
