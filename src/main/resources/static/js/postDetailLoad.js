(function () {
  const postId  = window.location.pathname.split('/').filter(Boolean).pop();
  const token   = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

  function formatDate(iso) {
    const d = new Date(iso);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      + ' · ' + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
  }

  function renderTrending(tags) {
    const list = document.getElementById('trending-tags-list');
    if (!list) return;
    if (!tags || tags.length === 0) {
      list.innerHTML = '<li class="trending-tag-empty">No trending topics yet.</li>';
      return;
    }
    list.innerHTML = '';
    tags.forEach((tag, i) => {
      const li = document.createElement('li');
      li.className = 'trending-tag-item';
      li.innerHTML = `<span class="trending-tag-rank">#${i + 1}</span><span class="trending-tag-name">${tag}</span>`;
      li.addEventListener('click', () => openTagPostsModal(tag));
      list.appendChild(li);
    });
  }

  let cachedPost = null;
  const raw = sessionStorage.getItem('pendingPostDetail');
  if (raw) {
    try {
      const parsed = JSON.parse(raw);
      if (String(parsed.postId) === String(postId)) cachedPost = parsed;
    } catch {}
    sessionStorage.removeItem('pendingPostDetail');
  }

  Promise.all([
    cachedPost
      ? Promise.resolve(cachedPost)
      : fetch(`/api/posts/${postId}`, { headers }).then(r => r.ok ? r.json() : null),
    fetch('/api/community/trending-tags').then(r => r.ok ? r.json() : [])
  ]).then(([post, trendingTags]) => {
    renderTrending(trendingTags);

    if (!post) {
      const nf = document.getElementById('post-not-found');
      if (nf) nf.style.display = 'block';
      return;
    }

    // blue header — clickable link to OP profile
    const headerEl = document.getElementById('post-detail-header-name');
    if (headerEl) headerEl.textContent = post.communityName ? 'c/' + post.communityName : 'u/' + post.authorUsername;
    const headerLink = document.getElementById('post-detail-header-link');
    if (headerLink) headerLink.href = post.communityName ? '/community/' + post.communityName : '/profile/' + post.authorUsername;

    // title
    const titleEl = document.getElementById('post-detail-title');
    if (titleEl) {
      if (post.title) titleEl.textContent = post.title;
      else titleEl.style.display = 'none';
    }

    // header row
    const usernameEl = document.getElementById('post-detail-username');
    if (usernameEl) {
      usernameEl.textContent = 'u/' + post.authorUsername;
      usernameEl.href = '/profile/' + post.authorUsername;
    }
    const dateEl = document.getElementById('post-detail-date');
    if (dateEl) dateEl.textContent = formatDate(post.createdAt);

    // body
    const bodyEl = document.getElementById('post-detail-body');
    if (bodyEl) bodyEl.textContent = post.contentText;

    // tags
    const tagsEl = document.getElementById('post-detail-tags');
    if (tagsEl && Array.isArray(post.tags) && post.tags.length) {
      tagsEl.innerHTML = post.tags.map(t => `<span class="community-tag">#${t}</span>`).join('');
    }

    // stats
    const statsEl = document.getElementById('post-detail-stats');
    if (statsEl) statsEl.textContent = `${post.likeCount ?? 0} likes · ${post.commentCount ?? 0} comments`;

    document.title = (post.title || 'Post') + ' - UniConn';
  }).catch(() => {
    const nf = document.getElementById('post-not-found');
    if (nf) { nf.textContent = 'Could not load post.'; nf.style.display = 'block'; }
  });
})();
