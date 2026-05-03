// Manages the notification bell modal. Loaded on all main pages.
document.addEventListener('DOMContentLoaded', () => {
  const token       = localStorage.getItem('token');
  const authHeaders = token ? { 'Authorization': 'Bearer ' + token } : {};

  // ---- in-memory state (one user's notifications + active filters) ----
  let allNotifications = [];
  let activeTypeFilter = 'ALL';   // 'ALL' | 'LIKE' | 'COMMENT' | 'FOLLOW' | 'USER_JOINED_COMMUNITY'
  let activeDateFilter = 'ALL';   // 'ALL' | 'TODAY' | 'WEEK' | 'MONTH'

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

  // ---- bell badge ----
  function updateBadge(count) {
    const badge = document.getElementById('notification-badge');
    if (!badge) return;
    if (count > 0) {
      badge.textContent = count > 9 ? '9+' : String(count);
      badge.style.display = 'inline-block';
    } else {
      badge.style.display = 'none';
    }
  }

  function loadUnreadCount() {
    if (!token) return;
    fetch('/api/notifications/unread-count', { headers: authHeaders })
      .then(r => r.ok ? r.json() : 0)
      .then(updateBadge)
      .catch(() => {});
  }

  // ---- mark a single notification as read (called when user clicks it) ----
  function markRead(notificationId, liElement) {
    if (!token) return Promise.resolve();
    return fetch('/api/notifications/' + notificationId + '/read', {
      method: 'PATCH',
      headers: authHeaders
    }).then(r => {
      if (r.ok) {
        liElement.classList.remove('notif-unread');
        const cached = allNotifications.find(x => x.id === notificationId);
        if (cached) cached.read = true;
        loadUnreadCount();
      }
    }).catch(() => {});
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

    // Click: mark read (only if currently unread), then navigate
    li.addEventListener('click', () => {
      const navigate = () => {
        if (n.type === 'FOLLOW') {
          window.location.href = '/profile/' + n.actorUsername;
        } else if (n.postId) {
          window.location.href = '/post/' + n.postId;
        }
      };
      if (n.read) {
        navigate();
      } else {
        markRead(n.id, li).then(navigate);
      }
    });

    return li;
  }

  // ---- filtering (runs over cached array, no network) ----
  function dateCutoff(filter) {
    const now = new Date();
    if (filter === 'TODAY') {
      const d = new Date(now); d.setHours(0,0,0,0); return d;
    }
    if (filter === 'WEEK')  return new Date(now.getTime() - 7  * 86400000);
    if (filter === 'MONTH') return new Date(now.getTime() - 30 * 86400000);
    return null;  // ALL
  }

  function applyFilters(notifications) {
    const cutoff = dateCutoff(activeDateFilter);
    return notifications.filter(n => {
      if (activeTypeFilter !== 'ALL' && n.type !== activeTypeFilter) return false;
      if (cutoff && new Date(n.createdAt) < cutoff) return false;
      return true;
    });
  }

  function renderList() {
    const list = document.getElementById('notification-list');
    if (!list) return;
    list.innerHTML = '';
    const visible = applyFilters(allNotifications);
    if (visible.length === 0) {
      list.innerHTML = '<li class="search-result-empty">No notifications match this filter.</li>';
      return;
    }
    visible.forEach(n => list.appendChild(renderNotification(n)));
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
        allNotifications = notifications || [];
        renderList();
        loadUnreadCount();
      })
      .catch(() => {
        list.innerHTML = '<li class="search-result-empty">No notifications yet.</li>';
      });
  }

  // ---- toolbar wiring (type dropdown, date dropdown, mark-all button) ----
  const typeSel = document.getElementById('notif-type-filter');
  if (typeSel) typeSel.addEventListener('change', () => {
    activeTypeFilter = typeSel.value;
    renderList();
  });

  const dateSel = document.getElementById('notif-date-filter');
  if (dateSel) dateSel.addEventListener('change', () => {
    activeDateFilter = dateSel.value;
    renderList();
  });

  // "Mark all as..." dropdown — value 'READ' or 'UNREAD' fires the matching bulk action
  const markAllSel = document.getElementById('notif-mark-all');
  if (markAllSel) markAllSel.addEventListener('change', () => {
    if (!token) { markAllSel.value = ''; return; }
    const action = markAllSel.value;
    if (action !== 'READ' && action !== 'UNREAD') return;

    const url        = action === 'READ' ? '/api/notifications/read-all' : '/api/notifications/unread-all';
    const newReadVal = (action === 'READ');

    fetch(url, { method: 'PATCH', headers: authHeaders })
      .then(r => r.ok ? r.json() : 0)
      .then(() => {
        allNotifications.forEach(n => n.read = newReadVal);
        renderList();
        loadUnreadCount();
      })
      .catch(() => {});

    markAllSel.value = '';   // reset back to placeholder so the same option can be picked again
  });

  // Initial badge load on page open (so badge appears before modal is opened)
  loadUnreadCount();
});
