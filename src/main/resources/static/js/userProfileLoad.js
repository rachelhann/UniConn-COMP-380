// Loads another user's profile page (/profile/{username}).
// Delegates post card rendering to postCardRenderer.js.

(function () {
  const token = localStorage.getItem('token');
  const authHeaders = token ? { 'Authorization': 'Bearer ' + token } : {};
  const viewedUsername = window.location.pathname.split('/').filter(Boolean).pop();
  const currentUsername = localStorage.getItem('currentUsername') || '';

  if (viewedUsername && viewedUsername === currentUsername) {
    window.location.replace('/profile');
    return;
  }

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

    overlay.querySelector('#liked-posts-close')
      .addEventListener('click', () => overlay.remove());

    overlay.addEventListener('click', e => {
      if (e.target === overlay) overlay.remove();
    });

    fetch(`/api/posts/liked-by/${targetUserId}`, { headers: authHeaders })
      .then(r => r.ok ? r.json() : [])
      .then(posts => {
        const list = document.getElementById('liked-posts-list');
        if (!list) return;

        if (!posts.length) {
          list.innerHTML = '<p style="color:#999;padding:8px">No liked posts yet.</p>';
          return;
        }

        list.innerHTML = '';
        posts.forEach(post => {
          const item = document.createElement('div');
          item.className = 'search-result-card';

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
        if (list) list.innerHTML = '<p style="color:#999;padding:8px">Error loading posts.</p>';
      });
  }

  function renderTrending(tags) {
    const trendingList = document.getElementById('trending-tags-list');
    if (!trendingList) return;

    if (!tags || tags.length === 0) {
      trendingList.innerHTML = '<li class="trending-tag-empty">No trending topics yet.</li>';
      return;
    }

    trendingList.innerHTML = '';
    tags.forEach((tag, i) => {
      const li = document.createElement('li');
      li.className = 'trending-tag-item';
      li.innerHTML = `<span class="trending-tag-rank">#${i + 1}</span><span class="trending-tag-name">${tag}</span>`;
      li.addEventListener('click', () => openTagPostsModal(tag));
      trendingList.appendChild(li);
    });
  }

  // ── controls (dropdown + liked button) ────────────────────────────
  function createControlBar(allPosts, profilePosts, communityPosts, targetUserId) {
    const wrapper = document.createElement('div');
    wrapper.className = 'posts-controls-wrapper';

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

	const likedBtn = document.createElement('button');
	likedBtn.className = 'liked-posts-btn';
	likedBtn.innerHTML = `<img src="/vector-logos/heartBlue.svg" alt="Liked"><span>Liked</span>`;
	likedBtn.addEventListener('click', () => openLikedPostsModal(targetUserId));

    wrapper.appendChild(filterBar);
    wrapper.appendChild(likedBtn);

    return wrapper;
  }

  function renderFilteredPosts(posts, controls) {
    const c = document.getElementById('profile-posts-container');
    if (!c) return;

    const ctrl = document.getElementById('profile-posts-controls');
    if (ctrl && controls) {
      ctrl.innerHTML = '';
      ctrl.appendChild(controls);
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

  // ── main fetch ────────────────────────────────────────────────────
  Promise.all([
    fetch(`/api/profile/${viewedUsername}`, { headers: authHeaders }).then(r => r.ok ? r.json() : null),
    fetch('/api/community/trending-tags').then(r => r.ok ? r.json() : []),
    token ? fetch('/api/users/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : []) : Promise.resolve([])
  ]).then(([profile, trendingTags, followingIds]) => {
    initPostViewModal();
    if (!profile) return;

    // profile rendering (unchanged)
    document.getElementById('profile-username').textContent = 'u/' + profile.username;
    document.getElementById('profile-fullname').textContent = profile.name || '';

    if (profile.profilePicture) {
      document.getElementById('profile-picture-img').src = profile.profilePicture;
    }

    document.getElementById('follower-count').textContent = profile.followerCount ?? 0;
    document.getElementById('following-count').textContent = profile.followingCount ?? 0;
    document.getElementById('community-count').textContent = profile.communityCount ?? 0;

    // ── follow button ──────────────────────────────────────────────
    const followBtn = document.getElementById('follow-profile-btn');
    const currentUsername = localStorage.getItem('currentUsername');
    if (followBtn && token && profile.username !== currentUsername) {
      const isFollowing = followingIds.includes(profile.userId);
      followBtn.textContent  = isFollowing ? 'Unfollow' : 'Follow';
      followBtn.classList.toggle('unfollow-btn', isFollowing);
      followBtn.style.display = '';

      followBtn.addEventListener('click', async () => {
        const following = followBtn.classList.contains('unfollow-btn');
        const res = await fetch(`/api/users/${profile.userId}/${following ? 'unfollow' : 'follow'}`, {
          method: following ? 'DELETE' : 'POST',
          headers: authHeaders
        });
        if (res.ok) {
          const nowFollowing = !following;
          followBtn.textContent = nowFollowing ? 'Unfollow' : 'Follow';
          followBtn.classList.toggle('unfollow-btn', nowFollowing);
          const countEl = document.getElementById('follower-count');
          countEl.textContent = parseInt(countEl.textContent) + (nowFollowing ? 1 : -1);
        }
      });
    }

    renderTrending(trendingTags);

    // ── followers / following modal ────────────────────────────────
    const followModal  = document.getElementById('follow-list-modal');
    const followTitle  = document.getElementById('follow-list-title');
    const followList   = document.getElementById('follow-list');
    const followClose  = document.getElementById('follow-list-close');

    function closeFollowModal() {
      followModal.classList.remove('active');
      followModal.setAttribute('aria-hidden', 'true');
    }

    if (followClose) followClose.addEventListener('click', closeFollowModal);
    if (followModal) followModal.addEventListener('click', e => { if (e.target === followModal) closeFollowModal(); });

    async function openFollowModal(type) {
      followTitle.textContent = type === 'followers' ? 'Followers' : 'Following';
      followList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
      followModal.classList.add('active');
      followModal.setAttribute('aria-hidden', 'false');

      const [users, myFollowingIds] = await Promise.all([
        fetch(`/api/users/${profile.userId}/${type}`, { headers: authHeaders }).then(r => r.ok ? r.json() : []),
        token ? fetch('/api/users/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : []) : Promise.resolve([])
      ]);

      const followingSet = new Set(myFollowingIds);
      followList.innerHTML = '';

      if (!users.length) {
        followList.innerHTML = `<li style="padding:12px 8px;color:#999;font-size:0.9em">No ${type} yet.</li>`;
        return;
      }

      users.forEach(u => {
        const isSelf = u.username === currentUsername;
        const isFollowing = followingSet.has(u.userId);
        const li = document.createElement('li');
        li.className = 'follow-list-item';
        li.style.cursor = 'pointer';
        li.innerHTML = `
          <img src="${u.profilePicture || '/vector-logos/usernameSignIn.svg'}" alt="" class="follow-list-avatar">
          <div class="follow-list-info">
            <span class="follow-list-username">u/${u.username}</span>
            ${u.name ? `<span class="follow-list-name">${u.name}</span>` : ''}
          </div>
          ${!isSelf ? `<button class="follow-btn ${isFollowing ? 'unfollow-btn' : ''}" data-uid="${u.userId}">${isFollowing ? 'Unfollow' : 'Follow'}</button>` : ''}
        `;
        li.addEventListener('click', e => {
          if (e.target.closest('.follow-btn')) return;
          window.location.href = '/profile/' + u.username;
        });
        if (!isSelf) {
          const btn = li.querySelector('.follow-btn');
          btn.addEventListener('click', async e => {
            e.stopPropagation();
            const following = btn.classList.contains('unfollow-btn');
            const res = await fetch(`/api/users/${u.userId}/${following ? 'unfollow' : 'follow'}`, {
              method: following ? 'DELETE' : 'POST',
              headers: authHeaders
            });
            if (res.ok) {
              btn.textContent = following ? 'Follow' : 'Unfollow';
              btn.classList.toggle('unfollow-btn', !following);
            }
          });
        }
        followList.appendChild(li);
      });
    }

    document.getElementById('stat-followers')?.addEventListener('click', () => openFollowModal('followers'));
    document.getElementById('stat-following')?.addEventListener('click', () => openFollowModal('following'));

    // ── communities modal ──────────────────────────────────────────
    const commModal      = document.getElementById('communities-modal');
    const commModalList  = document.getElementById('communities-modal-list');
    const commModalClose = document.getElementById('communities-modal-close');

    if (commModal) {
      commModalClose?.addEventListener('click', () => { commModal.classList.remove('active'); commModal.setAttribute('aria-hidden', 'true'); });
      commModal.addEventListener('click', e => { if (e.target === commModal) { commModal.classList.remove('active'); commModal.setAttribute('aria-hidden', 'true'); } });

      document.getElementById('stat-communities')?.addEventListener('click', async () => {
        commModalList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
        commModal.classList.add('active');
        commModal.setAttribute('aria-hidden', 'false');

        const communities = await fetch(`/api/community/user/${profile.userId}/communities`, { headers: authHeaders })
          .then(r => r.ok ? r.json() : []);

        commModalList.innerHTML = '';
        if (!communities.length) {
          commModalList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">No communities yet.</li>';
          return;
        }
        communities.forEach(c => {
          const li = document.createElement('li');
          li.className = 'follow-list-item';
          li.style.cursor = 'pointer';
          li.innerHTML = `
            <img src="${c.communityPicture || '/vector-logos/clubLogo.svg'}" alt="" class="follow-list-avatar">
            <div class="follow-list-info">
              <span class="follow-list-username">c/${c.communityName}</span>
              ${c.description ? `<span class="follow-list-name">${c.description}</span>` : ''}
            </div>
          `;
          li.addEventListener('click', () => window.location.href = '/community/' + c.communityName);
          commModalList.appendChild(li);
        });
      });
    }

    // ── posts fetch ────────────────────────────────────────────────
    return Promise.all([
      fetch(`/api/posts/profile/by-username/${viewedUsername}`, { headers: authHeaders }).then(r => r.ok ? r.json() : []),
      fetch(`/api/posts/user/${profile.userId}/community`, { headers: authHeaders }).then(r => r.ok ? r.json() : [])
    ]).then(([profilePosts, communityPosts]) => {

      const allPosts = [...profilePosts, ...communityPosts]
        .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

      const controls = createControlBar(
        allPosts,
        profilePosts,
        communityPosts,
        profile.userId
      );

      renderFilteredPosts(allPosts, controls);
      openPendingPostModal();
    });

  }).catch(() => {});

  function filterList(listId, query) {
    const q = query.toLowerCase();
    document.querySelectorAll(`#${listId} .follow-list-item`).forEach(li => {
      li.style.display = li.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  }

  document.getElementById('follow-search')?.addEventListener('input', e => filterList('follow-list', e.target.value.trim()));
  document.getElementById('communities-modal-search')?.addEventListener('input', e => filterList('communities-modal-list', e.target.value.trim()));
})();