// Manages the notification bell modal. Loaded on all main pages.
// Opens and closes the notifications modal.
// Notification data will be fetched from the backend once an endpoint is available.
initModal({
  modalId:  'notification-modal',
  toggleId: 'notification-toggle',
  closeId:  'notification-close',
  onOpen() {
    // future: fetch /api/notifications and populate #notification-list
  },
  onClose() {}
});
