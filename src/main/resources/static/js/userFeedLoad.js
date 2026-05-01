// Loads the main feed page (/feed).
// Delegates post card rendering and modal to postCardRenderer.js.

(function () {
  const token   = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

  if (!token) return;

  initPostViewModal();

  fetch('/api/profile/me', { headers })
    .then(r => r.ok ? r.json() : Promise.reject())
    .then(profile => {
      const currentUserId = profile.userId;
      if (!currentUserId) return;
      localStorage.setItem('currentUserId', currentUserId);

      // ── trending tags ─────────────────────────────────────────────
      fetch('/api/posts/trending', { headers })
        .then(r => r.ok ? r.json() : [])
        .then(tags => {
          const list = document.getElementById('trending-tags-list');
          if (!list) return;
          if (!tags || tags.length === 0) {
            list.innerHTML = '<li class="trending-tag-empty">No trending topics yet.</li>';
            return;
          }
          list.innerHTML = '';
          tags.slice(0, 5).forEach((tag, i) => {
            const li = document.createElement('li');
            li.className = 'trending-tag-item';
            li.innerHTML = `<span class="trending-tag-rank">#${i + 1}</span><span class="trending-tag-name">${tag.tagName}</span>`;
            li.addEventListener('click', () => {
              if (typeof openTagPostsModal === 'function') openTagPostsModal(tag.tagName);
            });
            list.appendChild(li);
          });
        })
        .catch(() => {});

      // ── feed posts ────────────────────────────────────────────────
      fetch(`/api/posts/feed/${currentUserId}`, { headers })
        .then(r => r.ok ? r.json() : [])
        .then(posts => renderPostList(posts, 'feed-posts-list'))
        .catch(() => renderPostList([], 'feed-posts-list'));
    })
    .catch(() => renderPostList([], 'feed-posts-list'));

})();