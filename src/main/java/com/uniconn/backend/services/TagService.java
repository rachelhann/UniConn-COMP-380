package com.uniconn.backend.services;

import org.springframework.stereotype.Service;
import com.uniconn.backend.entities.Tag;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.TagRepository;
import jakarta.transaction.Transactional;

@Service
public class TagService {
	private final TagRepository tagRepository;
	
	public TagService(TagRepository tagRepository) {
		this.tagRepository = tagRepository;
	}
	
	@Transactional
	public Tag findOrCreate(String rawName) {
		String tagName = rawName.toLowerCase().replaceAll("[^a-z0-9]", "");
		
		if(tagName.isEmpty()) {
		    throw new InvalidInputException("Invalid tag name: " + rawName);
		}
		return tagRepository.findByName(tagName)
				.orElseGet(() -> tagRepository.save(new Tag(tagName)));
	}

}
