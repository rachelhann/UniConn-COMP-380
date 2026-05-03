// Loads post cards on the logged-in user's own profile page (/profile).
// Delegates post card rendering to postCardRenderer.js.

(function () {
  const token   = localStorage.getItem('token');
  const headers = { 'Authorization': 'Bearer ' + token };
  const container = document.getElementById('profile-posts-container');

  if (!token) {
    if (container) container.innerHTML = '<p class="profile-posts-empty">No posts yet.</p>';
    return;
  }

  initPostViewModal();

  fetch('/api/profile/me', { headers })
    .then(r => r.ok ? r.json() : Promise.reject())
    .then(profile => {
      const userId = profile.userId;
      if (!userId) return;
      localStorage.setItem('currentUserId', userId);
      loadPosts(userId);
    })
    .catch(() => {
      if (container) container.innerHTML = '<p class="profile-posts-empty">No posts yet.</p>';
    });

  function loadPosts(userId) {

  function openPendingPostModal() {
    const raw = sessionStorage.getItem('pendingPostModal');
    if (!raw) return;
    sessionStorage.removeItem('pendingPostModal');
    try {
      const post = JSON.parse(raw);
      if (typeof openPostViewModal === 'function') openPostViewModal(post);
    } catch {}
  }

  // ── liked posts modal ─────────────────────────────────────────────
  function openLikedPostsModal(targetUserId) {
    const existing = document.getElementById('liked-posts-modal');
    if (existing) existing.remove();

    const overlay = document.createElement('div');
    overlay.id = 'liked-posts-modal';
    overlay.className = 'search-modal-overlay active';
    overlay.setAttribute('aria-hidden', 'false');

	overlay.innerHTML = `
	  <div class="search-modal create-post-modal">
	    <div class="header-right">
	      <h3 class="search-modal-title">Liked Posts</h3>
	    </div>
	    <button class="search-modal-close" id="liked-posts-close">&times;</button>
	    <div id="liked-posts-list" style="margin-top:12px; max-height:560px; overflow-y:auto;">
	      <p style="color:#999;font-size:0.9em;padding:8px">Loading...</p>
	    </div>
	  </div>
	`;
    document.body.appendChild(overlay);

    const closeBtn = overlay.querySelector('#liked-posts-close');
    closeBtn.addEventListener('click', () => overlay.remove());
    overlay.addEventListener('click', e => { if (e.target === overlay) overlay.remove(); });
    document.addEventListener('keydown', function onEsc(e) {
      if (e.key === 'Escape') { overlay.remove(); document.removeEventListener('keydown', onEsc); }
    });

    fetch(`/api/posts/liked-by/${targetUserId}`, { headers })
      .then(r => r.ok ? r.json() : [])
      .then(posts => {
        const list = document.getElementById('liked-posts-list');
        if (!list) return;
        if (!posts || posts.length === 0) {
          list.innerHTML = '<p style="color:#999;font-size:0.9em;padding:8px">No liked posts yet.</p>';
          return;
        }
        list.innerHTML = '';
        posts.forEach(post => {
          const item = document.createElement('div');
          item.className = 'search-result-card';
          item.style.cursor = 'pointer';
		  item.innerHTML = `
		    <div class="src-card-header">
		      <span class="src-card-name">${post.title || ('u/' + post.authorUsername)}</span>
		      ${post.communityName ? `<span class="post-card-community" style="font-size:0.8em">c/${post.communityName}</span>` : ''}
		    </div>
		    <p class="src-card-desc">${post.contentText || ''}</p>
		    <span style="font-size:0.78em;color:#aaa;display:flex;align-items:center;gap:4px;">
		      u/${post.authorUsername} · <img src="/vector-logos/heartBlue.svg" style="width:14px;height:14px;margin:0;display:inline-block;"> ${post.likeCount}
		    </span>
		  `;
          item.addEventListener('click', () => {
            overlay.remove();
            openPostViewModal(post);
          });
          list.appendChild(item);
        });
      })
      .catch(() => {
        const list = document.getElementById('liked-posts-list');
        if (list) list.innerHTML = '<p style="color:#999;font-size:0.9em;padding:8px">Could not load liked posts.</p>';
      });
  }

  // ── controls (FILTER + SEPARATE LIKE BUTTON) ──────────────────────
  function createControlBar(allPosts, profilePosts, communityPosts, targetUserId) {
    const wrapper = document.createElement('div');
    wrapper.className = 'posts-controls-wrapper';

    // LEFT -> dropdown
    const filterBar = document.createElement('div');
    filterBar.className = 'posts-filter-bar';

    const select = document.createElement('select');
    select.className = 'posts-filter-select';
    select.innerHTML = `
      <option value="all">All posts</option>
      <option value="profile">Profile posts</option>
      <option value="community">Community posts</option>
    `;

    select.addEventListener('change', () => {
      const val = select.value;
      const posts = val === 'all' ? allPosts
                  : val === 'profile' ? profilePosts
                  : communityPosts;
      renderFilteredPosts(posts, wrapper);
    });

    filterBar.appendChild(select);

    // RIGHT -> separate liked button
    const likedBtn = document.createElement('button');
    likedBtn.className = 'liked-posts-btn';
	likedBtn.innerHTML = `
	  <img src="/vector-logos/heartBlue.svg" alt="Liked">
	  <span>Liked</span>
	`;
    likedBtn.addEventListener('click', () => openLikedPostsModal(targetUserId));

    wrapper.appendChild(filterBar);
    wrapper.appendChild(likedBtn);

    return wrapper;
  }

  function renderFilteredPosts(posts, controlWrapper) {
    const c = document.getElementById('profile-posts-container');
    if (!c) return;

    const ctrl = document.getElementById('profile-posts-controls');
    if (ctrl && controlWrapper) {
      ctrl.innerHTML = '';
      ctrl.appendChild(controlWrapper);
    }

    c.innerHTML = '';

    if (!posts || posts.length === 0) {
      const empty = document.createElement('p');
      empty.style.cssText = 'color:#999;font-size:0.9em;padding:16px';
      empty.textContent = 'No posts yet.';
      c.appendChild(empty);
      return;
    }

    posts.forEach(post => c.appendChild(createPostCard(post)));
  }

  // ── fetch posts ───────────────────────────────────────────────────
  Promise.all([
    fetch(`/api/posts/profile/${userId}`, { headers }).then(r => r.ok ? r.json() : []),
    fetch(`/api/posts/user/${userId}/community`, { headers }).then(r => r.ok ? r.json() : [])
  ])
    .then(([profilePosts, communityPosts]) => {
      const allPosts = [...profilePosts, ...communityPosts]
        .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

      const controls = createControlBar(allPosts, profilePosts, communityPosts, userId);

      renderFilteredPosts(allPosts, controls);
      openPendingPostModal();
    })
    .catch(() => {
      if (container) container.innerHTML =
        '<p style="color:#999;font-size:0.9em;padding:16px">Could not load posts.</p>';
    });
  }

})();