(function () {
  const token = localStorage.getItem('token');
  if (!token) return;

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

  Promise.all([
    fetch('/api/profile/me', { headers: { 'Authorization': 'Bearer ' + token } })
      .then(res => { if (!res.ok) throw new Error('Not authenticated'); return res.json(); }),
    fetch('/api/community/trending-tags').then(r => r.ok ? r.json() : [])
  ]).then(([data, trendingTags]) => {
    renderTrending(trendingTags);

    const usernameEl = document.getElementById('profile-username');
    if (usernameEl) usernameEl.textContent = 'u/' + (data.username || '');
    if (data.username) localStorage.setItem('currentUsername', data.username);
    if (data.userId)   localStorage.setItem('currentUserId', data.userId);
	
	const fullnameEl = document.getElementById('profile-fullname');
	if (fullnameEl) fullnameEl.textContent = data.name || '';
	
    const avatarEl = document.getElementById('profile-picture-img');
    if (avatarEl && data.profilePicture) avatarEl.src = data.profilePicture;
    if (data.profilePicture) localStorage.setItem('profilePicture', data.profilePicture);

    const followerEl = document.getElementById('follower-count');
    const followingEl = document.getElementById('following-count');
    const communityEl = document.getElementById('community-count');
    if (followerEl)  followerEl.textContent  = data.followerCount  ?? 0;
    if (followingEl) followingEl.textContent = data.followingCount ?? 0;
    if (communityEl) communityEl.textContent = data.communityCount ?? 0;

	const bioSection = document.getElementById('profile-bio-section');
	if (bioSection) {
	  bioSection.innerHTML = '';
	  if (data.userBio) {
	    const bioEl = document.createElement('p');
	    bioEl.className = 'profile-bio';
	    bioEl.textContent = data.userBio;
	    bioSection.appendChild(bioEl);
	  } else {
	    const emptyEl = document.createElement('p');
	    emptyEl.className = 'profile-bio-empty';
	    emptyEl.textContent = 'No bio yet.';
	    bioSection.appendChild(emptyEl);
	  }
	}

    const nameInput = document.getElementById('edit-name-input');
    const bioInput  = document.getElementById('edit-bio-input');
    if (nameInput) nameInput.value = data.name    || '';
    if (bioInput)  bioInput.value  = data.userBio || '';

    // profile picture upload via avatar click
    const avatarWrap = document.getElementById('profile-avatar-wrap');
    const avatarImg  = document.getElementById('profile-picture-img');
    const picInput   = document.getElementById('profile-picture-input');
    if (avatarWrap && picInput) {
      avatarWrap.addEventListener('click', () => picInput.click());
      picInput.addEventListener('change', async () => {
        const file = picInput.files[0];
        if (!file) return;
        if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
          alert('Only JPG, PNG, or WebP images are allowed.');
          return;
        }
        if (file.size > 2 * 1024 * 1024) {
          alert('Image must be 2MB or smaller.');
          return;
        }
        const formData = new FormData();
        formData.append('file', file);
        const uploadRes = await fetch('/api/upload/user', {
          method: 'POST',
          headers: { 'Authorization': 'Bearer ' + token },
          body: formData
        });
        if (!uploadRes.ok) {
          const err = await uploadRes.json().catch(() => ({}));
          alert('Upload failed: ' + (err.error || uploadRes.status));
          return;
        }
        const { url } = await uploadRes.json();
        const saveRes = await fetch('/api/profile/me/picture', {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token },
          body: JSON.stringify({ url })
        });
        if (saveRes.ok) {
          if (avatarImg) avatarImg.src = url;
          localStorage.setItem('profilePicture', url);
        } else {
          const err = await saveRes.json().catch(() => ({}));
          alert('Failed to save picture: ' + (err.error || saveRes.status));
        }
      });
    }

    // followers / following modal
    const followModal   = document.getElementById('follow-list-modal');
    const followTitle   = document.getElementById('follow-list-title');
    const followList    = document.getElementById('follow-list');
    const followClose   = document.getElementById('follow-list-close');
    const profileUserId = data.userId;

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

      const [users, followingIds] = await Promise.all([
        fetch(`/api/users/${profileUserId}/${type}`, { headers: { 'Authorization': 'Bearer ' + token } })
          .then(r => r.ok ? r.json() : []),
        fetch('/api/users/following/ids', { headers: { 'Authorization': 'Bearer ' + token } })
          .then(r => r.ok ? r.json() : [])
      ]);

      const currentUsername = localStorage.getItem('currentUsername') || '';
      const followingSet = new Set(followingIds);
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
              headers: { 'Authorization': 'Bearer ' + token }
            });
            if (res.ok) {
              btn.textContent = following ? 'Follow' : 'Unfollow';
              btn.classList.toggle('unfollow-btn', !following);
              const followingEl = document.getElementById('following-count');
              if (followingEl) followingEl.textContent = parseInt(followingEl.textContent) + (following ? -1 : 1);
            }
          });
        }
        followList.appendChild(li);
      });
    }

    document.getElementById('stat-followers')?.addEventListener('click', () => openFollowModal('followers'));
    document.getElementById('stat-following')?.addEventListener('click', () => openFollowModal('following'));

    // communities modal
    const commModal     = document.getElementById('communities-modal');
    const commModalList = document.getElementById('communities-modal-list');
    const commModalClose = document.getElementById('communities-modal-close');

    if (commModal) {
      commModalClose?.addEventListener('click', () => { commModal.classList.remove('active'); commModal.setAttribute('aria-hidden', 'true'); });
      commModal.addEventListener('click', e => { if (e.target === commModal) { commModal.classList.remove('active'); commModal.setAttribute('aria-hidden', 'true'); } });

      document.getElementById('stat-communities')?.addEventListener('click', async () => {
        commModalList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
        commModal.classList.add('active');
        commModal.setAttribute('aria-hidden', 'false');

        const communities = await fetch(`/api/community/user/${profileUserId}/communities`, { headers: { 'Authorization': 'Bearer ' + token } })
          .then(r => r.ok ? r.json() : []);

        commModalList.innerHTML = '';
        if (!communities.length) {
          commModalList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">No communities yet.</li>';
          return;
        }
        const currentUser = localStorage.getItem('currentUsername') || '';
        communities.forEach(c => {
          const isAdmin = c.createdByUsername === currentUser;
          const li = document.createElement('li');
          li.className = 'follow-list-item';
          li.style.cursor = 'pointer';
          li.innerHTML = `
            <img src="${c.communityPicture || '/vector-logos/clubLogo.svg'}" alt="" class="follow-list-avatar">
            <div class="follow-list-info">
              <span class="follow-list-username">c/${c.communityName}</span>
              ${c.description ? `<span class="follow-list-name">${c.description}</span>` : ''}
            </div>
            ${!isAdmin ? `<button class="follow-btn unfollow-btn">Leave</button>` : ''}
          `;
          li.addEventListener('click', e => {
            if (e.target.closest('.follow-btn')) return;
            window.location.href = '/community/' + c.communityName;
          });
          if (!isAdmin) {
            const btn = li.querySelector('.follow-btn');
            btn.addEventListener('click', async e => {
              e.stopPropagation();
              const leaving = btn.classList.contains('unfollow-btn');
              const res = await fetch(`/api/community/${c.communityId}/${leaving ? 'leave' : 'join'}`, {
                method: leaving ? 'DELETE' : 'POST',
                headers: { 'Authorization': 'Bearer ' + token }
              });
              if (res.ok) {
                btn.textContent = leaving ? 'Join' : 'Leave';
                btn.classList.toggle('unfollow-btn', !leaving);
                const communityEl = document.getElementById('community-count');
                if (communityEl) communityEl.textContent = parseInt(communityEl.textContent) + (leaving ? -1 : 1);
              }
            });
          }
          commModalList.appendChild(li);
        });
      });
    }
  })
  .catch(() => {});

  // --- Search filters for follow and communities modals ---
  function filterList(listId, query) {
    const q = query.toLowerCase();
    document.querySelectorAll(`#${listId} .follow-list-item`).forEach(li => {
      const text = li.textContent.toLowerCase();
      li.style.display = text.includes(q) ? '' : 'none';
    });
  }

  document.getElementById('follow-search')?.addEventListener('input', e => {
    filterList('follow-list', e.target.value.trim());
  });
  document.getElementById('communities-modal-search')?.addEventListener('input', e => {
    filterList('communities-modal-list', e.target.value.trim());
  });

  // Clear search inputs when modals open
  document.getElementById('stat-followers')?.addEventListener('click', () => {
    const s = document.getElementById('follow-search');
    if (s) { s.value = ''; filterList('follow-list', ''); }
  });
  document.getElementById('stat-following')?.addEventListener('click', () => {
    const s = document.getElementById('follow-search');
    if (s) { s.value = ''; filterList('follow-list', ''); }
  });
  document.getElementById('stat-communities')?.addEventListener('click', () => {
    const s = document.getElementById('communities-modal-search');
    if (s) { s.value = ''; filterList('communities-modal-list', ''); }
  });
})();
