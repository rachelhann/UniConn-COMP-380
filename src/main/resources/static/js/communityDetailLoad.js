(function () {
  const id = window.location.pathname.split('/').pop();
  const token = localStorage.getItem('jwt');

  const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

  function render(community) {
    const headerName = document.getElementById('community-header-name');
    if (headerName) headerName.textContent = community.communityName || 'Community';

    const categoryEl = document.getElementById('community-category');
    if (categoryEl) categoryEl.textContent = fmt(community.category);

    const memberEl = document.getElementById('community-member-count');
    if (memberEl) memberEl.textContent = community.memberCount ?? 1;

    const descEl = document.getElementById('community-description');
    if (descEl) descEl.textContent = community.description || '';

    const createdByEl = document.getElementById('community-created-by');
    if (createdByEl) createdByEl.textContent = 'u/' + (community.createdByUsername || '');

    const tagsEl = document.getElementById('community-tags');
    if (tagsEl && Array.isArray(community.tags) && community.tags.length > 0) {
      tagsEl.innerHTML = community.tags
        .map(t => `<span class="community-tag">#${t}</span>`)
        .join('');
    }
  }

  // Try API first, fall back to sessionStorage (used right after creation)
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};
  fetch('/api/community/' + id, { headers })
    .then(res => {
      if (!res.ok) throw new Error('not found');
      return res.json();
    })
    .then(community => {
      sessionStorage.removeItem('communityDetail');
      render(community);
    })
    .catch(() => {
      const raw = sessionStorage.getItem('communityDetail');
      if (!raw) return;
      sessionStorage.removeItem('communityDetail');
      try { render(JSON.parse(raw)); } catch {}
    });
})();
