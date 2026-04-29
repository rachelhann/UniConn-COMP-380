document.addEventListener('DOMContentLoaded', () => {
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

  function debounce(fn, delay) {
    let timer;
    return function(...args) {
      clearTimeout(timer);
      timer = setTimeout(() => fn.apply(this, args), delay);
    };
  }

  async function performSearch(query) {
    const results = document.getElementById('search-results');
    if (!query || query.length === 0) {
      results.innerHTML = '';
      return;
    }

    results.innerHTML = '<li class="search-result-empty">Searching...</li>';

    try {
      const activeFilter = document.querySelector('.search-filter-btn.active')?.dataset.filter || 'all';

      const [data, followingIds] = await Promise.all([
        fetch(`/api/search?q=${encodeURIComponent(query)}`, { headers: authHeaders }).then(r => r.json()),
        token
          ? fetch('/api/users/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : [])
          : Promise.resolve([])
      ]);

      let users = data.users || [];
      let communities = data.communities || [];
      let posts = data.posts || [];
      let tags = [];

      if (activeFilter === 'users') { communities = []; posts = []; }
      if (activeFilter === 'communities') { users = []; posts = []; }
      if (activeFilter === 'posts') { users = []; communities = []; }

      if (activeFilter === 'all' || activeFilter === 'tags') {
        const res = await fetch(`/api/search/tags?q=${encodeURIComponent(query)}`, { headers: authHeaders });
        tags = await res.json();
        if (activeFilter === 'tags') { users = []; communities = []; posts = []; }
      }

      results.innerHTML = '';
      const hasResults = users.length > 0 || communities.length > 0 || posts.length > 0 || tags.length > 0;

      if (!hasResults) {
        results.innerHTML = `<li class="search-result-empty">No results found for "${query}"</li>`;
        return;
      }

      const followingSet = new Set(followingIds);

      users.forEach(u => {
        const isSelf = u.username === currentUsername;
        const isFollowing = followingSet.has(u.userId);
        const li = document.createElement('li');
        li.className = 'search-result-card';
        li.innerHTML = `
          <div class="src-card-row">
            <img src="${u.profilePicture || '/vector-logos/usernameSignIn.svg'}" alt="" class="src-card-icon">
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

        li.addEventListener('click', (e) => {
          if (e.target.closest('.follow-btn')) return;
          window.location.href = '/profile/' + u.username;
        });
        results.appendChild(li);
      });

      communities.forEach(c => {
        const li = document.createElement('li');
        li.className = 'search-result-card';
        li.innerHTML = `
          <div class="src-card-row">
            <img src="${c.communityPicture || '/vector-logos/clubLogo.svg'}" alt="" class="src-card-icon">
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
        li.style.cursor = 'pointer';
        li.addEventListener('click', () => window.location.href = '/community/' + c.communityName);
        results.appendChild(li);
      });

      posts.forEach(p => {
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

      tags.forEach(t => {
        const li = document.createElement('li');
        li.className = 'search-result-card';
        li.innerHTML = `
          <div class="src-card-row">
            <div class="src-card-body">
              <div class="src-card-header">
                <span class="src-card-name">#${t.name}</span>
              </div>
            </div>
          </div>
        `;
        li.style.cursor = 'pointer';
        li.addEventListener('click', () => window.location.href = '/communities?tag=' + t.name);
        results.appendChild(li);
      });

    } catch (err) {
      results.innerHTML = '<li class="search-result-empty">Could not connect to server.</li>';
    }
  }

  const debouncedSearch = debounce(function() {
    const query = document.getElementById('search-input').value.trim();
    performSearch(query);
  }, 300);

  document.getElementById('search-input').addEventListener('input', debouncedSearch);
  document.getElementById('search-input').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') performSearch(this.value.trim());
  });

  const modal = document.querySelector('.search-modal');
  if (!modal) return;

  const filterBar = document.createElement('div');
  filterBar.className = 'search-filter-bar';
  filterBar.innerHTML = `
    <button class="search-filter-btn active" data-filter="all">All</button>
    <button class="search-filter-btn" data-filter="users">Users</button>
    <button class="search-filter-btn" data-filter="communities">Communities</button>
    <button class="search-filter-btn" data-filter="posts">Posts</button>
    <button class="search-filter-btn" data-filter="tags">Tags</button>
  `;

  const input = modal.querySelector('.search-modal-input');
  if (input) input.insertAdjacentElement('afterend', filterBar);

  filterBar.addEventListener('click', function(e) {
    if (!e.target.classList.contains('search-filter-btn')) return;
    document.querySelectorAll('.search-filter-btn').forEach(b => b.classList.remove('active'));
    e.target.classList.add('active');
    const query = document.getElementById('search-input').value.trim();
    if (query) performSearch(query);
  });

  const style = document.createElement('style');
  style.textContent = `
    .search-filter-bar {
      display: flex;
      gap: 6px;
      padding: 6px 0;
      flex-wrap: wrap;
    }
    .search-filter-btn {
      padding: 4px 12px;
      border-radius: 20px;
      border: 1px solid #a0b4c8;
      background: white;
      color: #2E75B6;
      font-size: 12px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .search-filter-btn.active {
      background: #2E75B6;
      color: white;
      border-color: #2E75B6;
    }
    .search-filter-btn:hover {
      background: #2E75B6;
      color: white;
    }
  `;
  document.head.appendChild(style);

  const modalStyle = document.createElement('style');
  modalStyle.textContent = `
    .search-modal {
      display: flex;
      flex-direction: column;
      max-height: 80vh;
      overflow: hidden;
    }
    .search-results-list {
      overflow-y: auto;
      max-height: 50vh;
      margin: 0;
      padding: 0;
      list-style: none;
    }
  `;
  document.head.appendChild(modalStyle);
});
