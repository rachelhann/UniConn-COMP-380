(function () {
  const list = document.getElementById('my-communities-list');
  if (!list) return;

  const token = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

  const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

  function render(communities) {
    if (communities.length === 0) {
      list.innerHTML = '<p class="my-communities-empty">You have not joined or created any communities yet.</p>';
      return;
    }

    communities.forEach(c => {
      const card = document.createElement('div');
      card.className = 'mc-card';
      card.addEventListener('click', () => {
        sessionStorage.setItem('communityDetail', JSON.stringify(c));
        window.location.href = '/community/' + c.communityName;
      });

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
          </div>
          <span class="mc-card-members">${c.memberCount ?? 1} members</span>
          <p class="mc-card-desc">${c.description || ''}</p>
          ${tags ? `<div class="mc-card-tags">${tags}</div>` : ''}
        </div>
      `;

      list.appendChild(card);
    });
  }

  fetch('/api/community/my-communities', { headers })
    .then(res => {
      if (!res.ok) throw new Error();
      return res.json();
    })
    .then(render)
    .catch(() => {
      const local = JSON.parse(localStorage.getItem('myCommunities') || '[]');
      render(local);
    });
})();
