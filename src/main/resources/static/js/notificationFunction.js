// Manages the notification bell modal. Loaded on all main pages.
document.addEventListener('DOMContentLoaded', () => {
  const token       = localStorage.getItem('token');
  const authHeaders = token ? { 'Authorization': 'Bearer ' + token } : {};

  initModal({
    modalId:  'notification-modal',
    toggleId: 'notification-toggle',
    closeId:  'notification-close',
    onOpen()  { loadNotifications(); },
    onClose() {}
  });

  function timeAgo(iso) {
    const mins = Math.floor((Date.now() - new Date(iso).getTime()) / 60000);
    if (mins < 1)  return 'just now';
    if (mins < 60) return `${mins}m ago`;
    const hrs = Math.floor(mins / 60);
    if (hrs < 24)  return `${hrs}h ago`;
    return `${Math.floor(hrs / 24)}d ago`;
  }

  function renderNotification(n) {
    const li = document.createElement('li');
    li.className = 'search-result-card' + (n.read ? '' : ' notif-unread');

    const icon = n.actorProfilePicture || '/vector-logos/usernameSignIn.svg';
    const time = n.createdAt ? timeAgo(n.createdAt) : '';

    let actionText = '';
    let descText   = '';

    if (n.type === 'FOLLOW') {
      actionText = 'followed you';
    } else if (n.type === 'LIKE') {
      actionText = 'liked your post';
      descText   = n.postTitle || '';
    } else if (n.type === 'COMMENT') {
      actionText = 'commented on your post';
      descText   = n.commentText || n.postTitle || '';
    } else {
      actionText = n.message || '';
    }

    li.innerHTML = `
      <div class="src-card-row">
        <img src="${icon}" alt="" class="src-card-icon">
        <div class="src-card-body">
          <div class="src-card-header">
            <span class="src-card-name">u/${n.actorUsername}</span>
            <span class="src-card-members">${time}</span>
          </div>
          <p class="src-card-desc">${actionText}${descText ? ' · ' + descText : ''}</p>
        </div>
      </div>
    `;

    if (n.type === 'FOLLOW') {
      li.addEventListener('click', () => window.location.href = '/profile/' + n.actorUsername);
    } else if (n.postId) {
      li.addEventListener('click', () => window.location.href = '/post/' + n.postId);
    }

    return li;
  }

  function loadNotifications() {
    const list = document.getElementById('notification-list');
    if (!list) return;

    list.innerHTML = '<li class="search-result-empty">Loading...</li>';

    if (!token) {
      list.innerHTML = '<li class="search-result-empty">Sign in to see notifications.</li>';
      return;
    }

    fetch('/api/notifications', { headers: authHeaders })
      .then(r => r.ok ? r.json() : Promise.reject())
      .then(notifications => {
        list.innerHTML = '';
        if (!notifications || notifications.length === 0) {
          list.innerHTML = '<li class="search-result-empty">No notifications yet.</li>';
          return;
        }
        notifications.forEach(n => list.appendChild(renderNotification(n)));
      })
      .catch(() => {
        list.innerHTML = '<li class="search-result-empty">No notifications yet.</li>';
      });
  }
});
