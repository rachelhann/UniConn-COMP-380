package com.uniconn.backend.listeners;

import com.uniconn.backend.entities.Community;
import com.uniconn.backend.entities.CommunityMember;
import com.uniconn.backend.entities.CommunityMemberRole;
import com.uniconn.backend.entities.User;
import com.uniconn.backend.events.PostCreatedEvent;
import com.uniconn.backend.repositories.CommunityMemberRepository;
import com.uniconn.backend.repositories.CommunityRepository;
import com.uniconn.backend.repositories.UserRepository;
import com.uniconn.backend.services.NotificationService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

import java.util.List;

// Bridges domain events (e.g. PostCreatedEvent) to notification creation.
// This class is the only place that knows "PostCreatedEvent maps to ADMIN_POST notifications".
// Services and controllers stay free of notification logic.
@Component
public class NotificationEventListener {

    private final CommunityMemberRepository communityMemberRepository;
    private final CommunityRepository communityRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public NotificationEventListener(CommunityMemberRepository communityMemberRepository,
                                     CommunityRepository communityRepository,
                                     UserRepository userRepository,
                                     NotificationService notificationService) {
        this.communityMemberRepository = communityMemberRepository;
        this.communityRepository = communityRepository;
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    // Runs AFTER_COMMIT (post is safely persisted) and on a separate thread (@Async)
    // so post creation is not slowed down by the notification fan-out.
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onPostCreated(PostCreatedEvent event) {
        // 1. only community posts trigger this notification
        if (event.getCommunityId() == null) {
            return;
        }

        // 2. only ADMIN or MODERATOR posts trigger this notification (single targeted query)
        boolean isAdminOrMod = communityMemberRepository
                .existsById_CommunityIdAndId_UserIdAndRoleIn(
                        event.getCommunityId(),
                        event.getAuthorId(),
                        List.of(CommunityMemberRole.ADMIN, CommunityMemberRole.MODERATOR));
        if (!isAdminOrMod) {
            return;
        }

        // 3. fetch what we need to build the notification message
        Community community = communityRepository.findById(event.getCommunityId()).orElse(null);
        User author = userRepository.findById(event.getAuthorId()).orElse(null);
        if (community == null || author == null) {
            return;   // post was deleted / data gone; nothing to do
        }

        // 4. fan out: notify every member except the author
        List<CommunityMember> members =
                communityMemberRepository.findByCommunity_CommunityId(event.getCommunityId());
        for (CommunityMember m : members) {
            User recipient = m.getUser();
            if (recipient.getUserId().equals(event.getAuthorId())) {
                continue;   // skip the author (they posted it)
            }
            notificationService.createAdminPostNotification(
                    recipient,
                    author,
                    event.getPostId(),
                    event.getCommunityId(),
                    community.getCommunityName());
        }
    }
}
