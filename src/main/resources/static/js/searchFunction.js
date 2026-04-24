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

document.getElementById('search-input').addEventListener('keydown', async function(e) {
  if (e.key !== 'Enter') return;
  const query = this.value.trim();
  if (!query) return;

  const results = document.getElementById('search-results');
  results.innerHTML = '<li>Searching...</li>';

  try {
    const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`);
    const data = await response.json();
    results.innerHTML = '';

    const hasResults = data.users.length > 0 || data.communities.length > 0 || data.posts.length > 0;

    if (!hasResults) {
      results.innerHTML = `<li>No results found for "${query}"</li>`;
      return;
    }

    data.users.forEach(u => {
      const li = document.createElement('li');
      li.innerHTML = `<strong>👤 @${u.username}</strong>${u.userBio ? `<br><small>${u.userBio}</small>` : ''}`;
      li.style.cursor = 'pointer';
      li.addEventListener('click', () => window.location.href = '/profile?user=' + u.username);
      results.appendChild(li);
    });

    data.communities.forEach(c => {
      const li = document.createElement('li');
      li.innerHTML = `<strong>🏘️ ${c.communityName}</strong>${c.description ? `<br><small>${c.description}</small>` : ''}`;
      li.style.cursor = 'pointer';
      li.addEventListener('click', () => window.location.href = '/community/' + c.communityId);
      results.appendChild(li);
    });

    data.posts.forEach(p => {
      const li = document.createElement('li');
      li.innerHTML = `<strong>📝 ${p.title || p.contentText}</strong><br><small>by @${p.authorUsername}</small>`;
      li.style.cursor = 'pointer';
      results.appendChild(li);
    });

  } catch (err) {
    results.innerHTML = '<li>Could not connect to server.</li>';
  }
});