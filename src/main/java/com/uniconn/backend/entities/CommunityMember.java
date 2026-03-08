package com.uniconn.backend.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import java.util.Date;
import com.uniconn.backend.composite_keys.CommunityMemberId;

@Table(name = "community_member")
@Entity
public class CommunityMember {
	@EmbeddedId
	private CommunityMemberId id;
	
	@ManyToOne
	@MapsId("communityId")
	@JoinColumn(name = "community_id")
	private Community community;
	
	@ManyToOne
	@MapsId("userId")
	@JoinColumn(name = "user_id")
	private User user;
	
	@CreationTimestamp
	@Column(name = "joined_at")
	private Date joinedAt;
	
	public CommunityMember() {}
	
	//getters&setters
	public CommunityMemberId getId() {
		return id;
	}

	public void setId(CommunityMemberId id) {
		this.id = id;
	}

	public Community getCommunity() {
		return community;
	}

	public void setCommunity(Community community) {
		this.community = community;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Date getJoinedAt() {
		return joinedAt;
	}
	
}
