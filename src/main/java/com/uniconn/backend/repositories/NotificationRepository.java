package com.uniconn.backend.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.uniconn.backend.entities.Notification;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {
	// All notifications for one user, newest first
	List<Notification> findByRecipient_UserIdOrderByCreatedAtDesc(Integer userId);

	// How many unread notifications a user has (powers the bell badge count)
	long countByRecipient_UserIdAndIsReadFalse(Integer userId);

	// All unread notifications for one user (used by markAllAsRead so we only update unread rows)
	List<Notification> findByRecipient_UserIdAndIsReadFalse(Integer userId);

	// All read notifications for one user (used by markAllAsUnread so we only update read rows)
	List<Notification> findByRecipient_UserIdAndIsReadTrue(Integer userId);
}
