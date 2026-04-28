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

<<<<<<< HEAD
=======
const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

>>>>>>> dev
document.getElementById('search-input').addEventListener('keydown', async function(e) {
  if (e.key !== 'Enter') return;
  const query = this.value.trim();
  if (!query) return;

  const results = document.getElementById('search-results');
<<<<<<< HEAD
  results.innerHTML = '<li>Searching...</li>';

  try {
    const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`);
=======
  results.innerHTML = '<li class="search-result-empty">Searching...</li>';

  try {
    const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`, {
      headers: { 'Authorization': 'Bearer ' + localStorage.getItem('jwt') }
    });
>>>>>>> dev
    const data = await response.json();
    results.innerHTML = '';

    const hasResults = data.users.length > 0 || data.communities.length > 0 || data.posts.length > 0;

    if (!hasResults) {
<<<<<<< HEAD
      results.innerHTML = `<li>No results found for "${query}"</li>`;
=======
      results.innerHTML = `<li class="search-result-empty">No results found for "${query}"</li>`;
>>>>>>> dev
      return;
    }

    data.users.forEach(u => {
      const li = document.createElement('li');
<<<<<<< HEAD
      li.innerHTML = `<strong>User: @${u.username}</strong>${u.userBio ? `<br><small>${u.userBio}</small>` : ''}`;
      li.style.cursor = 'pointer';
      li.addEventListener('click', () => window.location.href = '/user-profile?user=' + u.username);
=======
      li.className = 'search-result-card';
      li.innerHTML = `
        <div class="src-card-row">
          <img src="/vector-logos/usernameSignIn.svg" alt="" class="src-card-icon">
          <div class="src-card-body">
            <div class="src-card-header">
              <span class="src-card-name">u/${u.username}</span>
            </div>
            ${u.userBio ? `<p class="src-card-desc">${u.userBio}</p>` : ''}
          </div>
        </div>
      `;
      li.addEventListener('click', () => window.location.href = '/profile?user=' + u.username);
>>>>>>> dev
      results.appendChild(li);
    });

    data.communities.forEach(c => {
      const li = document.createElement('li');
<<<<<<< HEAD
      li.innerHTML = `<strong>Community: ${c.communityName}</strong>${c.description ? `<br><small>${c.description}</small>` : ''}`;
      li.style.cursor = 'pointer';
      li.addEventListener('click', () => window.location.href = '/community/' + c.communityId);
=======
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
>>>>>>> dev
      results.appendChild(li);
    });

    data.posts.forEach(p => {
      const li = document.createElement('li');
<<<<<<< HEAD
      li.innerHTML = `<strong>Post: ${p.title || p.contentText}</strong><br><small>by @${p.authorUsername}</small>`;
      li.style.cursor = 'pointer';
=======
      li.className = 'search-result-card';
      li.innerHTML = `
        <div class="src-card-header">
          <span class="src-card-name">${p.title || p.contentText || ''}</span>
        </div>
        <span class="src-card-members">u/${p.authorUsername}</span>
        ${p.contentText ? `<p class="src-card-desc">${p.contentText}</p>` : ''}
      `;
>>>>>>> dev
      results.appendChild(li);
    });

  } catch (err) {
<<<<<<< HEAD
    results.innerHTML = '<li>Could not connect to server.</li>';
  }
});
=======
    results.innerHTML = '<li class="search-result-empty">Could not connect to server.</li>';
  }
});
>>>>>>> dev
