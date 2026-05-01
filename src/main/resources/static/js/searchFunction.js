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

function sectionLabel(text) {
  const li = document.createElement('li');
  li.style.cssText = 'list-style:none;padding:8px 4px 2px;font-size:0.78em;font-weight:700;color:#888;text-transform:uppercase;letter-spacing:0.05em;border-top:1px solid #eee;margin-top:4px';
  li.textContent = text;
  return li;
}

let _searchTimer = null;
document.getElementById('search-input').addEventListener('input', function() {
  clearTimeout(_searchTimer);
  const input = this;
  _searchTimer = setTimeout(async function() {
  const query = input.value.trim();
  if (!query) { document.getElementById('search-results').innerHTML = ''; return; }

  const results = document.getElementById('search-results');
  results.innerHTML = '<li class="search-result-empty">Searching...</li>';

  try {
    const [data, followingIds, tagPosts] = await Promise.all([
      fetch(`/api/search?q=${encodeURIComponent(query)}`, { headers: authHeaders }).then(r => r.json()),
      token
        ? fetch('/api/users/following/ids', { headers: authHeaders }).then(r => r.ok ? r.json() : [])
        : Promise.resolve([]),
      fetch(`/api/posts/search?q=${encodeURIComponent(query)}`, { headers: authHeaders }).then(r => r.ok ? r.json() : [])
    ]);

    results.innerHTML = '';

    const existingPostIds = new Set((data.posts || []).map(p => p.postId));
    const dedupedTagPosts = tagPosts.filter(p => !existingPostIds.has(p.postId));

    const hasResults = data.users.length > 0 || data.communities.length > 0
      || data.posts.length > 0 || dedupedTagPosts.length > 0;

    if (!hasResults) {
      results.innerHTML = `<li class="search-result-empty">No results found for "${query}"</li>`;
      return;
    }

    const followingSet = new Set(followingIds);

    // --- Users ---
    if (data.users.length > 0) {
      results.appendChild(sectionLabel('Users'));
      data.users.forEach(u => {
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
    }

    // --- Communities ---
    if (data.communities.length > 0) {
      results.appendChild(sectionLabel('Communities'));
      data.communities.forEach(c => {
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
        li.addEventListener('click', () => window.location.href = '/community/' + c.communityName);
        results.appendChild(li);
      });
    }

    // --- Posts (title/content match) ---
    if (data.posts.length > 0) {
      results.appendChild(sectionLabel('Posts'));
      data.posts.forEach(p => {
        const li = document.createElement('li');
        li.className = 'search-result-card';
        li.innerHTML = `
          <div class="src-card-header">
            <span class="src-card-name">${p.title || ''}</span>
            <a href="/profile/${p.authorUsername}" class="src-card-members post-username-link" onclick="event.stopPropagation()">u/${p.authorUsername}</a>
          </div>
          ${p.contentText ? `<p class="src-card-desc">${p.contentText}</p>` : ''}
        `;
        li.addEventListener('click', () => {
          sessionStorage.setItem('pendingPostDetail', JSON.stringify(p));
          window.location.href = '/post/' + p.postId;
        });
        results.appendChild(li);
      });
    }

    // --- Posts by tag (tag contains match) ---
    if (dedupedTagPosts.length > 0) {
      results.appendChild(sectionLabel('Posts by tag'));
      dedupedTagPosts.forEach(p => {
        const li = document.createElement('li');
        li.className = 'search-result-card';
        const meta = `<a href="/profile/${p.authorUsername}" class="post-username-link" onclick="event.stopPropagation()">u/${p.authorUsername}</a>`
          + (p.communityName ? ' · c/' + p.communityName : '');
        const tagsHtml = Array.isArray(p.tags) && p.tags.length
          ? '<div style="display:flex;flex-wrap:wrap;gap:4px;margin-top:4px">'
            + p.tags.map(t => `<span style="background:#f0f0f0;border-radius:20px;padding:2px 8px;font-size:0.78em;color:#555">#${t}</span>`).join('')
            + '</div>'
          : '';
        li.innerHTML = `
          <span class="src-card-members">${meta}</span>
          ${p.title ? `<p class="src-card-name" style="margin:4px 0 2px">${p.title}</p>` : ''}
          <p class="src-card-desc">${p.contentText}</p>
          ${tagsHtml}
        `;
        li.addEventListener('click', () => {
          sessionStorage.setItem('pendingPostDetail', JSON.stringify(p));
          window.location.href = '/post/' + p.postId;
        });
        results.appendChild(li);
      });
    }

  } catch (err) {
    results.innerHTML = '<li class="search-result-empty">Could not connect to server.</li>';
  }
  }, 300);
});
});