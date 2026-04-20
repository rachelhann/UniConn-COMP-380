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

    const allResults = [
      ...data.users.map(u => ({ label: `👤 @${u.username}`, sub: u.userBio || '' })),
      ...data.communities.map(c => ({ label: `🏘️ ${c.communityName}`, sub: c.description || '' })),
      ...data.posts.map(p => ({ label: `📝 ${p.title || p.contentText}`, sub: `by @${p.authorUsername}` }))
    ];

    if (allResults.length === 0) {
      results.innerHTML = `<li>No results for "${query}"</li>`;
      return;
    }

    allResults.forEach(item => {
      const li = document.createElement('li');
      li.innerHTML = `<strong>${item.label}</strong>${item.sub ? `<br><small>${item.sub}</small>` : ''}`;
      results.appendChild(li);
    });

  } catch (err) {
    results.innerHTML = '<li>Could not connect to server.</li>';
  }
});
