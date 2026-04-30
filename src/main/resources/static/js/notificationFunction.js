// Opens and closes the notifications modal, and fetches notifications when opened.

initModal({
  modalId:  'notification-modal',
  toggleId: 'notification-toggle',
  closeId:  'notification-close',
  onOpen()  { loadNotifications(); },
  onClose() {}
});

function loadNotifications() {
  const list = document.getElementById('notification-list');
  if (!list) return;

  const token = localStorage.getItem('token');
  if (!token) {
    list.innerHTML = '<li class="notification-empty">Please log in to view notifications.</li>';
    return;
  }

  list.innerHTML = '<li class="notification-empty">Loading...</li>';

  fetch('/api/notifications', {
    headers: { 'Authorization': 'Bearer ' + token }
  })
    .then(res => {
      if (!res.ok) throw new Error('Failed to load: ' + res.status);
      return res.json();
    })
    .then(notifications => {
      if (notifications.length === 0) {
        list.innerHTML = '<li class="notification-empty">No notifications yet.</li>';
        return;
      }
      list.innerHTML = '';
      notifications.forEach(n => {
        const li = document.createElement('li');
        li.className = 'notification-item';
        li.textContent = n.message;
        list.appendChild(li);
      });
    })
    .catch(err => {
      console.error('Failed to load notifications:', err);
      list.innerHTML = '<li class="notification-empty">Could not load notifications.</li>';
    });
}
