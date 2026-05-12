package com.uniconn.backend.controllers;

import com.uniconn.backend.dtos.NotificationResponseDTO;
import com.uniconn.backend.services.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    // GET /api/notifications
    @GetMapping
    public ResponseEntity<List<NotificationResponseDTO>> getMyNotifications() {
        return ResponseEntity.ok(notificationService.getMyNotifications());
    }

    // PATCH /api/notifications/{id}/read
    @PatchMapping("/{id}/read")
    public ResponseEntity<NotificationResponseDTO> markAsRead(@PathVariable Integer id) {
        return ResponseEntity.ok(notificationService.markAsRead(id));
    }

    // GET /api/notifications/unread-count
    @GetMapping("/unread-count")
    public ResponseEntity<Long> getUnreadCount() {
        return ResponseEntity.ok(notificationService.getUnreadCount());
    }

    // PATCH /api/notifications/read-all
    @PatchMapping("/read-all")
    public ResponseEntity<Integer> markAllAsRead() {
        return ResponseEntity.ok(notificationService.markAllAsRead());
    }

    // PATCH /api/notifications/unread-all
    @PatchMapping("/unread-all")
    public ResponseEntity<Integer> markAllAsUnread() {
        return ResponseEntity.ok(notificationService.markAllAsUnread());
    }

    // DELETE /api/notifications  ->  { "deletedCount": <n> }
    @DeleteMapping
    public ResponseEntity<Map<String, Integer>> deleteAllNotifications() {
        int count = notificationService.deleteAllNotifications();
        return ResponseEntity.ok(Map.of("deletedCount", count));
    }
}
