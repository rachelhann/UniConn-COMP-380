package com.uniconn.backend.services;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.uniconn.backend.exception.*;

@Service
public class ImageUploadService {
	
	private static final long MAX_SIZE_BYTES = 2L * 1024 * 1024; // 2MB
	private static final java.util.Set<String> ALLOWED_TYPES = java.util.Set.of(
			"image/jpeg", "image/png", "image/webp"
			);
	
	private final Cloudinary cloudinary;
	
	public ImageUploadService(Cloudinary cloudinary) {
		this.cloudinary = cloudinary;
	}
	
	/**
     * Uploads an image to Cloudinary and returns the secure URL.
     *
     * @param file   the uploaded file
     * @param folder "users" or "communities" — controls the folder in Cloudinary
     * @return secure Cloudinary URL to store in DB
     */
	
	public String upload(MultipartFile file, String folder) {
		validateFile(file);
		
		try {
			String publicId = "uniconn/" + folder + "/" + UUID.randomUUID();
			
			Map<?, ?> result = cloudinary.uploader().upload(
					file.getBytes(),
					ObjectUtils.asMap(
						"public_id", publicId,
						"overwrite", true,
						"resource_type", "image"							
					)
			);
			
			return (String) result.get("secure_url");
			
		} catch (IOException e) {
			throw new RuntimeException("Image upload failed. Please try again");
		}
	}
	
	private void validateFile(MultipartFile file) {
		
		if(file == null || file.isEmpty()) {
			throw new InvalidInputException("Please select image to upload");			
		}
		
		if(!ALLOWED_TYPES.contains(file.getContentType())) {
			throw new InvalidInputException("Only JPEG, PNG, and WebP images are allowed");
		}
		
		if(file.getSize() > MAX_SIZE_BYTES) {
			throw new InvalidInputException("Image must be under 2MB");	
		}
	}

}
