package com.uniconn.backend.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.uniconn.backend.entities.Notification;
import com.uniconn.backend.entities.Notification.NotificationType;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {
	// All notifications for one user, newest first
	List<Notification> findByRecipient_UserIdOrderByCreatedAtDesc(Integer userId);

	// How many unread notifications a user has 
	long countByRecipient_UserIdAndIsReadFalse(Integer userId);

	// All unread notifications for one user
	List<Notification> findByRecipient_UserIdAndIsReadFalse(Integer userId);

	// All read notifications for one user 
	List<Notification> findByRecipient_UserIdAndIsReadTrue(Integer userId);

	boolean existsByRecipient_UserIdAndTypeAndPostId(
			Integer userId, NotificationType type, Integer postId);
}
