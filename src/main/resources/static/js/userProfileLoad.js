(function () {
  const token = localStorage.getItem('token');
  const authHeaders = token ? { 'Authorization': 'Bearer ' + token } : {};
  const viewedUsername = window.location.pathname.split('/').filter(Boolean).pop();
  const currentUsername = localStorage.getItem('currentUsername') || '';

  // redirect to own profile if someone navigates to their own /profile/{username}
  if (viewedUsername && viewedUsername === currentUsername) {
    window.location.replace('/profile');
    return;
  }

  function formatDate(iso) {
    const d = new Date(iso);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      + ' · '
      + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
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
      li.addEventListener('click', () => { window.location.href = '/communities?tag=' + encodeURIComponent(tag); });
      trendingList.appendChild(li);
    });
  }

  function renderPosts(posts) {
    renderPostList(posts, 'profile-posts-container');
  }

  function setupFollowModal(profileUserId, initialFollowingIds) {
    const followModal = document.getElementById('follow-list-modal');
    const followTitle = document.getElementById('follow-list-title');
    const followList  = document.getElementById('follow-list');
    const followClose = document.getElementById('follow-list-close');
    if (!followModal) return;

    function closeFollowModal() {
      followModal.classList.remove('active');
      followModal.setAttribute('aria-hidden', 'true');
    }

    followClose?.addEventListener('click', closeFollowModal);
    followModal.addEventListener('click', e => { if (e.target === followModal) closeFollowModal(); });

    async function openFollowModal(type) {
      followTitle.textContent = type === 'followers' ? 'Followers' : 'Following';
      followList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
      followModal.classList.add('active');
      followModal.setAttribute('aria-hidden', 'false');

      const [users, followingIds] = await Promise.all([
        fetch(`/api/users/${profileUserId}/${type}`, { headers: authHeaders }).then(r => r.ok ? r.json() : []),
        fetch('/api/users/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : [])
      ]);

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
  }

  Promise.all([
    fetch(`/api/profile/${viewedUsername}`, { headers: authHeaders }).then(r => r.ok ? r.json() : null),
    fetch(`/api/posts/profile/by-username/${viewedUsername}`, { headers: authHeaders }).then(r => r.ok ? r.json() : []),
    fetch('/api/community/trending-tags').then(r => r.ok ? r.json() : []),
    token ? fetch('/api/users/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : []) : Promise.resolve([])
  ]).then(([profile, posts, trendingTags, followingIds]) => {
	initPostViewModal();
    if (!profile) return;

    // header
    const headerEl = document.getElementById('profile-header');
    if (headerEl) headerEl.textContent = 'Profile';

    // username
    const usernameEl = document.getElementById('profile-username');
    if (usernameEl) usernameEl.textContent = 'u/' + (profile.username || '');
	
	// full name
	const fullnameEl = document.getElementById('profile-fullname');
	if (fullnameEl) fullnameEl.textContent = profile.name || '';
	
    // avatar
    const avatarEl = document.getElementById('profile-picture-img');
    if (avatarEl && profile.profilePicture) avatarEl.src = profile.profilePicture;

    // stats
    const followerEl = document.getElementById('follower-count');
    const followingEl = document.getElementById('following-count');
    const communityEl = document.getElementById('community-count');
    if (followerEl)  followerEl.textContent  = profile.followerCount  ?? 0;
    if (followingEl) followingEl.textContent = profile.followingCount ?? 0;
    if (communityEl) communityEl.textContent = profile.communityCount ?? 0;

    // bio
	const bioSection = document.getElementById('profile-bio-section');
	if (bioSection) {
	  bioSection.innerHTML = '';
	  if (profile.userBio) {
	    const bioEl = document.createElement('p');
	    bioEl.className = 'profile-bio';
	    bioEl.textContent = profile.userBio;
	    bioSection.appendChild(bioEl);
	  } else {
	    const emptyEl = document.createElement('p');
	    emptyEl.className = 'profile-bio-empty';
	    emptyEl.textContent = 'No bio yet.';
	    bioSection.appendChild(emptyEl);
	  }
	}

    // follow / unfollow button
    const followBtn = document.getElementById('follow-profile-btn');
    if (followBtn && profile.userId) {
      const isFollowing = new Set(followingIds).has(profile.userId);
      followBtn.textContent = isFollowing ? 'Unfollow' : 'Follow';
      followBtn.className = 'follow-btn' + (isFollowing ? ' unfollow-btn' : '');
      followBtn.style.display = '';
      followBtn.addEventListener('click', async () => {
        const following = followBtn.classList.contains('unfollow-btn');
        const res = await fetch(`/api/users/${profile.userId}/${following ? 'unfollow' : 'follow'}`, {
          method: following ? 'DELETE' : 'POST',
          headers: authHeaders
        });
        if (res.ok) {
          followBtn.textContent = following ? 'Follow' : 'Unfollow';
          followBtn.classList.toggle('unfollow-btn', !following);
          const count = document.getElementById('follower-count');
          if (count) count.textContent = parseInt(count.textContent) + (following ? -1 : 1);
        }
      });
    }

    renderPosts(posts);
    renderTrending(trendingTags);
    if (profile.userId) setupFollowModal(profile.userId, followingIds);

    // communities modal
    const commModal      = document.getElementById('communities-modal');
    const commModalList  = document.getElementById('communities-modal-list');
    const commModalClose = document.getElementById('communities-modal-close');

    if (commModal && profile.userId) {
      commModalClose?.addEventListener('click', () => { commModal.classList.remove('active'); commModal.setAttribute('aria-hidden', 'true'); });
      commModal.addEventListener('click', e => { if (e.target === commModal) { commModal.classList.remove('active'); commModal.setAttribute('aria-hidden', 'true'); } });

      document.getElementById('stat-communities')?.addEventListener('click', async () => {
        commModalList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
        commModal.classList.add('active');
        commModal.setAttribute('aria-hidden', 'false');

        const [communities, myCommunities] = await Promise.all([
          fetch(`/api/community/user/${profile.userId}/communities`, { headers: authHeaders }).then(r => r.ok ? r.json() : []),
          fetch('/api/community/my-communities', { headers: authHeaders }).then(r => r.ok ? r.json() : [])
        ]);

        const myIds = new Set(myCommunities.map(c => c.communityId));

        commModalList.innerHTML = '';
        if (!communities.length) {
          commModalList.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">No communities yet.</li>';
          return;
        }
        communities.forEach(c => {
          const isMember = myIds.has(c.communityId);
          const isMyAdmin = c.createdByUsername === currentUsername;
          const li = document.createElement('li');
          li.className = 'follow-list-item';
          li.style.cursor = 'pointer';
          li.innerHTML = `
            <img src="${c.communityPicture || '/vector-logos/clubLogo.svg'}" alt="" class="follow-list-avatar">
            <div class="follow-list-info">
              <span class="follow-list-username">c/${c.communityName}</span>
              ${c.description ? `<span class="follow-list-name">${c.description}</span>` : ''}
            </div>
            ${!isMyAdmin ? `<button class="follow-btn ${isMember ? 'unfollow-btn' : ''}">${isMember ? 'Leave' : 'Join'}</button>` : ''}
          `;
          li.addEventListener('click', e => {
            if (e.target.closest('.follow-btn')) return;
            window.location.href = '/community/' + c.communityName;
          });
          if (!isMyAdmin) {
            const btn = li.querySelector('.follow-btn');
            btn.addEventListener('click', async e => {
              e.stopPropagation();
              const leaving = btn.classList.contains('unfollow-btn');
              const res = await fetch(`/api/community/${c.communityId}/${leaving ? 'leave' : 'join'}`, {
                method: leaving ? 'DELETE' : 'POST',
                headers: authHeaders
              });
              if (res.ok) {
                btn.textContent = leaving ? 'Join' : 'Leave';
                btn.classList.toggle('unfollow-btn', !leaving);
              }
            });
          }
          commModalList.appendChild(li);
        });
      });
    }
  }).catch(() => {});
})();
