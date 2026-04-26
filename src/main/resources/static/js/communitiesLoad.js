(function () {
  const list = document.getElementById('communities-list');
  if (!list) return;

  const token = localStorage.getItem('token');
  const authHeaders = token ? { 'Authorization': 'Bearer ' + token } : {};
  const currentUsername = localStorage.getItem('currentUsername') || '';
  const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

  const activeTag = new URLSearchParams(window.location.search).get('tag');

  // fetch all communities, user's memberships, and trending tags in parallel
  Promise.all([
    fetch('/api/community/all', { headers: authHeaders }).then(r => r.ok ? r.json() : []),
    token
      ? fetch('/api/community/my-communities', { headers: authHeaders }).then(r => r.ok ? r.json() : [])
      : Promise.resolve([]),
    fetch('/api/community/trending-tags').then(r => r.ok ? r.json() : [])
  ]).then(([communities, myCommunities, trendingTags]) => {
    renderTrending(trendingTags);

    const filtered = activeTag
      ? communities.filter(c => Array.isArray(c.tags) && c.tags.includes(activeTag))
      : communities;

    const joinedIds = new Set(myCommunities.map(c => c.communityId));

    if (filtered.length === 0) {
      list.innerHTML = '<p class="my-communities-empty">No communities found.</p>';
      return;
    }

    filtered.forEach(c => {
      const isMember = joinedIds.has(c.communityId);
      const isAdmin = c.createdByUsername === currentUsername;
      const card = document.createElement('div');
      card.className = 'mc-card';

      const tags = Array.isArray(c.tags) && c.tags.length > 0
        ? c.tags.map(t => `<span class="mc-tag">#${t}</span>`).join('')
        : '';

      card.innerHTML = `
        <div class="mc-card-left">
          <img src="/vector-logos/clubLogo.svg" alt="" class="mc-card-icon">
        </div>
        <div class="mc-card-body">
          <div class="mc-card-header">
            <span class="mc-card-name">c/${c.communityName || ''}</span>
            <span class="mc-card-category">${fmt(c.category)}</span>
            ${!isAdmin ? `<button class="join-leave-btn ${isMember ? 'leave-btn' : 'join-btn'}" data-id="${c.communityId}">${isMember ? 'Leave' : 'Join'}</button>` : ''}
          </div>
          <span class="mc-card-members">${c.memberCount ?? 0} members</span>
          <p class="mc-card-desc">${c.description || ''}</p>
          ${tags ? `<div class="mc-card-tags">${tags}</div>` : ''}
        </div>
      `;

      card.addEventListener('click', (e) => {
        if (e.target.closest('.join-leave-btn')) return;
        sessionStorage.setItem('communityDetail', JSON.stringify(c));
        window.location.href = '/community/' + c.communityName;
      });

      if (!isAdmin) {
        const btn = card.querySelector('.join-leave-btn');
        btn.addEventListener('click', async (e) => {
          e.stopPropagation();
          const joined = btn.classList.contains('leave-btn');
          const res = await fetch(`/api/community/${c.communityId}/${joined ? 'leave' : 'join'}`, {
            method: joined ? 'DELETE' : 'POST',
            headers: authHeaders
          });
          if (res.ok) {
            btn.textContent = joined ? 'Join' : 'Leave';
            btn.classList.toggle('join-btn', joined);
            btn.classList.toggle('leave-btn', !joined);
          }
        });
      }

      list.appendChild(card);
    });
  }).catch(() => {
    list.innerHTML = '<p class="my-communities-empty">Could not load communities.</p>';
  });

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
})();
