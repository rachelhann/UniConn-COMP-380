package com.uniconn.backend.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.uniconn.backend.entities.Notification;

public interface NotificationRepository extends JpaRepository<Notification, Integer> {
	// All notifications for one user, newest first
	List<Notification> findByRecipient_UserIdOrderByCreatedAtDesc(Integer userId);
}
