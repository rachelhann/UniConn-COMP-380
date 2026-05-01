(function () {
  const list = document.getElementById('communities-list');
  if (!list) return;

  let activeCategory = 'all';

  function applyFilters() {
    const q = (document.getElementById('communities-search')?.value || '').trim().toLowerCase();
    list.querySelectorAll('.mc-card').forEach(card => {
      const name = (card.querySelector('.mc-card-name')?.textContent || '').toLowerCase();
      const tags = (card.querySelector('.mc-card-tags')?.textContent || '').toLowerCase();
      const cat  = (card.dataset.category || '').toLowerCase();
      const matchesSearch   = !q || name.includes(q) || tags.includes(q);
      const matchesCategory = activeCategory === 'all' || cat === activeCategory;
      card.style.display = (matchesSearch && matchesCategory) ? '' : 'none';
    });
  }

  const searchInput = document.getElementById('communities-search');
  if (searchInput) searchInput.addEventListener('input', applyFilters);

  document.querySelectorAll('.mc-filter-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.mc-filter-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      activeCategory = btn.dataset.category;
      applyFilters();
    });
  });

  document.getElementById('explore-btn')?.classList.add('active');

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

    // edit modal setup
    const editModal     = document.getElementById('edit-community-modal');
    const editDescInput = document.getElementById('edit-community-desc-input');
    const editMsg       = document.getElementById('edit-community-message');
    let editingCommunity = null;

    if (editModal) {
      initTagBubbles('edit-community-tags-container', 'edit-community-tags-input');

      document.getElementById('edit-community-close')?.addEventListener('click', () => {
        editModal.classList.remove('active');
        editModal.setAttribute('aria-hidden', 'true');
      });
      editModal.addEventListener('click', e => {
        if (e.target === editModal) {
          editModal.classList.remove('active');
          editModal.setAttribute('aria-hidden', 'true');
        }
      });
      document.getElementById('edit-community-submit')?.addEventListener('click', async () => {
        if (!editingCommunity) return;
        editMsg.style.display = 'none';
        editMsg.className = 'profile-message';

        const description = editDescInput.value.trim();
        const tags = getTagsFrom('edit-community-tags-container');
        const res = await fetch(`/api/community/${editingCommunity.communityId}/update`, {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json', ...authHeaders },
          body: JSON.stringify({ description, tags })
        });
        if (res.ok) {
          editMsg.textContent = 'Community updated.';
          editMsg.classList.add('success');
          editMsg.style.display = 'block';
          const cardDesc = editingCommunity._cardEl?.querySelector('.mc-card-desc');
          if (cardDesc) cardDesc.textContent = description;
          editingCommunity.description = description;
          editingCommunity.tags = tags;
        } else {
          editMsg.textContent = 'Failed to update. Please try again.';
          editMsg.classList.add('error');
          editMsg.style.display = 'block';
        }
      });
    }

    filtered.forEach(c => {
      const isMember = joinedIds.has(c.communityId);
      const isAdmin = c.createdByUsername === currentUsername;
      const card = document.createElement('div');
      card.className = 'mc-card';
      card.dataset.category = (c.category || '').toLowerCase();

      const tags = Array.isArray(c.tags) && c.tags.length > 0
        ? c.tags.map(t => `<span class="mc-tag">#${t}</span>`).join('')
        : '';

      card.innerHTML = `
        <div class="mc-card-left">
          <img src="${c.communityPicture || '/vector-logos/clubLogo.svg'}" alt="" class="mc-card-icon">
        </div>
        <div class="mc-card-body">
          <div class="mc-card-header">
            <span class="mc-card-name">c/${c.communityName || ''}</span>
            <span class="mc-card-category">${fmt(c.category)}</span>
            ${isAdmin
              ? `<button class="join-leave-btn update-btn" data-id="${c.communityId}">Update</button>`
              : `<button class="join-leave-btn ${isMember ? 'leave-btn' : 'join-btn'}" data-id="${c.communityId}">${isMember ? 'Leave' : 'Join'}</button>`}
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

      const btn = card.querySelector('.join-leave-btn');
      if (isAdmin && editModal) {
        btn.addEventListener('click', (e) => {
          e.stopPropagation();
          editingCommunity = c;
          editingCommunity._cardEl = card;
          editDescInput.value = c.description || '';
          populateTagBubbles('edit-community-tags-container', 'edit-community-tags-input', c.tags || []);
          document.getElementById('edit-community-tags-input').value = '';
          editMsg.style.display = 'none';
          editMsg.className = 'profile-message';
          editModal.classList.add('active');
          editModal.setAttribute('aria-hidden', 'false');
        });
      } else if (!isAdmin) {
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
      li.addEventListener('click', () => openTagPostsModal(tag));
      trendingList.appendChild(li);
    });
  }
})();
