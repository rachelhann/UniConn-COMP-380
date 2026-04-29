package com.uniconn.backend.repositories;

import com.uniconn.backend.composite_keys.PostTagId;
import com.uniconn.backend.entities.PostTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PostTagRepository extends JpaRepository<PostTag, PostTagId> {
    void deleteByPost_PostId(Integer postId);
}