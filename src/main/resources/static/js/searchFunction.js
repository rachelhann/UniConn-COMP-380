initModal({
  modalId:  'search-modal',
  toggleId: 'search-toggle',
  closeId:  'search-close',
  onOpen() {
    const input   = document.getElementById('search-input');
    const results = document.getElementById('search-results');
    input.value       = '';
    results.innerHTML = '';
    input.focus();
  }
});

const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

const token = localStorage.getItem('token');
const authHeaders = token ? { 'Authorization': 'Bearer ' + token } : {};
const currentUsername = localStorage.getItem('currentUsername') || '';

document.getElementById('search-input').addEventListener('keydown', async function(e) {
  if (e.key !== 'Enter') return;
  const query = this.value.trim();
  if (!query) return;

  const results = document.getElementById('search-results');
  results.innerHTML = '<li class="search-result-empty">Searching...</li>';

  try {
    const [data, followingIds] = await Promise.all([
      fetch(`/api/search?q=${encodeURIComponent(query)}`, { headers: authHeaders }).then(r => r.json()),
      token
        ? fetch('/api/user/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : [])
        : Promise.resolve([])
    ]);

    results.innerHTML = '';

    const hasResults = data.users.length > 0 || data.communities.length > 0 || data.posts.length > 0;

    if (!hasResults) {
      results.innerHTML = `<li class="search-result-empty">No results found for "${query}"</li>`;
      return;
    }

    const followingSet = new Set(followingIds);

    data.users.forEach(u => {
      const isSelf = u.username === currentUsername;
      const isFollowing = followingSet.has(u.userId);

      const li = document.createElement('li');
      li.className = 'search-result-card';
      li.innerHTML = `
        <div class="src-card-row">
          <img src="/vector-logos/usernameSignIn.svg" alt="" class="src-card-icon">
          <div class="src-card-body">
            <div class="src-card-header">
              <span class="src-card-name">u/${u.username}</span>
              ${!isSelf ? `<button class="follow-btn ${isFollowing ? 'unfollow-btn' : ''}" data-uid="${u.userId}">${isFollowing ? 'Unfollow' : 'Follow'}</button>` : ''}
            </div>
            ${u.userBio ? `<p class="src-card-desc">${u.userBio}</p>` : ''}
          </div>
        </div>
      `;

      if (!isSelf) {
        const btn = li.querySelector('.follow-btn');
        btn.addEventListener('click', async (e) => {
          e.stopPropagation();
          const following = btn.classList.contains('unfollow-btn');
          const res = await fetch(`/api/user/${u.userId}/${following ? 'unfollow' : 'follow'}`, {
            method: following ? 'DELETE' : 'POST',
            headers: authHeaders
          });
          if (res.ok) {
            btn.textContent = following ? 'Follow' : 'Unfollow';
            btn.classList.toggle('unfollow-btn', !following);
          }
        });
      }

      li.addEventListener('click', (e) => {
        if (e.target.closest('.follow-btn')) return;
        window.location.href = '/profile?user=' + u.username;
      });
      results.appendChild(li);
    });

    data.communities.forEach(c => {
      const li = document.createElement('li');
      li.className = 'search-result-card';
      li.innerHTML = `
        <div class="src-card-row">
          <img src="/vector-logos/clubLogo.svg" alt="" class="src-card-icon">
          <div class="src-card-body">
            <div class="src-card-header">
              <span class="src-card-name">c/${c.communityName}</span>
              ${c.category ? `<span class="mc-card-category">${fmt(c.category)}</span>` : ''}
            </div>
            <span class="src-card-members">${c.memberCount ?? 0} members</span>
            ${c.description ? `<p class="src-card-desc">${c.description}</p>` : ''}
          </div>
        </div>
      `;
      li.addEventListener('click', () => window.location.href = '/community/' + c.communityName);
      results.appendChild(li);
    });

    data.posts.forEach(p => {
      const li = document.createElement('li');
      li.className = 'search-result-card';
      li.innerHTML = `
        <div class="src-card-header">
          <span class="src-card-name">${p.title || p.contentText || ''}</span>
        </div>
        <span class="src-card-members">u/${p.authorUsername}</span>
        ${p.contentText ? `<p class="src-card-desc">${p.contentText}</p>` : ''}
      `;
      results.appendChild(li);
    });

  } catch (err) {
    results.innerHTML = '<li class="search-result-empty">Could not connect to server.</li>';
  }
});
