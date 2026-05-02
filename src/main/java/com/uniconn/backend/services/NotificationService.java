package com.uniconn.backend.services;

import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.entities.Notification.NotificationType;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class NotificationService extends BaseService {

    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    // ---------------------------------------------------------------
    // CREATE NOTIFICATION (called by other services)
    // ---------------------------------------------------------------
    @Transactional
    public void createNotification(User recipient, User sender, NotificationType type,
                                   Integer postId, Integer commentId) {
        // Don't notify yourself (e.g., liking your own post)
        if (sender != null && sender.getUserId().equals(recipient.getUserId())) {
            return;
        }

        Notification n = new Notification();
        n.setRecipient(recipient);
        n.setSender(sender);
        n.setType(type);
        n.setPostId(postId);
        n.setCommentId(commentId);
        n.setMessage(buildMessage(sender, type));
        notificationRepository.save(n);
    }

    // ---------------------------------------------------------------
    // CREATE COMMUNITY-JOIN NOTIFICATION
    // ---------------------------------------------------------------
    @Transactional
    public void createCommunityJoinNotification(User recipient, User sender,
                                                Integer communityId, String communityName) {
    
        if (sender != null && sender.getUserId().equals(recipient.getUserId())) {
            return;
        }

        Notification n = new Notification();
        n.setRecipient(recipient);
        n.setSender(sender);
        n.setType(NotificationType.USER_JOINED_COMMUNITY);
        n.setCommunityId(communityId);
        n.setMessage(sender.getUsername() + " joined your community " + communityName);
        notificationRepository.save(n);
    }

    // ---------------------------------------------------------------
    // GET MY NOTIFICATIONS
    // ---------------------------------------------------------------
    @Transactional(readOnly = true)
    public List<NotificationResponseDTO> getMyNotifications() {
        User currentUser = getAuthenticatedUser();
        return notificationRepository
                .findByRecipient_UserIdOrderByCreatedAtDesc(currentUser.getUserId())
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    // ---------------------------------------------------------------
    // MARK AS READ
    // ---------------------------------------------------------------
    @Transactional
    public NotificationResponseDTO markAsRead(Integer notificationId) {
        User currentUser = getAuthenticatedUser();

        Notification n = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new ResourceNotFoundException("Notification not found: " + notificationId));

        // Security: you can only mark your own notifications as read
        if (!n.getRecipient().getUserId().equals(currentUser.getUserId())) {
            throw new UnauthorizedException("You cannot modify this notification");
        }

        n.setRead(true);
        Notification saved = notificationRepository.save(n);
        return mapToDTO(saved);
    }

    // ---------------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------------
    private String buildMessage(User sender, NotificationType type) {
        String name = (sender == null) ? "Someone" : sender.getUsername();
        return switch (type) {
            case POST_LIKED -> name + " liked your post";
            case POST_COMMENTED -> name + " commented on your post";
            case NEW_FOLLOWER -> name + " started following you";
            case USER_JOINED_COMMUNITY -> name + " joined your community";
        };
    }

    private NotificationResponseDTO mapToDTO(Notification n) {
        NotificationResponseDTO dto = new NotificationResponseDTO();
        dto.setId(n.getNotificationId());
        dto.setType(n.getType().name());
        dto.setMessage(n.getMessage());
        if (n.getSender() != null) {
            dto.setSenderUsername(n.getSender().getUsername());
            dto.setSenderProfilePicture(n.getSender().getProfilePicture());
        }
        dto.setPostId(n.getPostId());
        dto.setCommunityId(n.getCommunityId());
        dto.setRead(n.isRead());
        dto.setCreatedAt(n.getCreatedAt());
        return dto;
    }
}
