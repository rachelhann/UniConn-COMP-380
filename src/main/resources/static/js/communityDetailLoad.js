(function () {
  const communityName = window.location.pathname.split('/').pop();
  const token = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

  const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

  const currentUsername = localStorage.getItem('currentUsername') || '';

  function render(community, isMember) {
    const communityNameEl = document.getElementById('community-detail-name');
    if (communityNameEl) communityNameEl.textContent = 'c/' + (community.communityName || '');

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

    // join/leave button
    const isAdmin = community.createdByUsername === currentUsername;

    // community icon — show current picture, make clickable for admin
    const iconWrap = document.getElementById('community-icon-wrap');
    const iconImg  = document.getElementById('community-icon-img');
    if (iconImg && community.communityPicture) iconImg.src = community.communityPicture;

    if (isAdmin && iconWrap) {
      iconWrap.classList.add('admin-clickable');
      const picInput = document.getElementById('community-picture-input');
      iconWrap.addEventListener('click', () => picInput.click());
      picInput.addEventListener('change', async () => {
        const file = picInput.files[0];
        if (!file) return;
        if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
          alert('Only JPG, PNG, or WebP images are allowed.');
          return;
        }
        if (file.size > 2 * 1024 * 1024) {
          alert('Image must be 2MB or smaller.');
          return;
        }

        const formData = new FormData();
        formData.append('file', file);

        const uploadRes = await fetch('/api/upload/community', { method: 'POST', headers, body: formData });
        if (!uploadRes.ok) {
          const err = await uploadRes.json().catch(() => ({}));
          alert('Upload failed: ' + (err.error || uploadRes.status));
          return;
        }
        const { url } = await uploadRes.json();

        const picRes = await fetch(`/api/community/${community.communityId}/picture`, {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json', ...headers },
          body: JSON.stringify({ url })
        });
        if (picRes.ok) {
          if (iconImg) iconImg.src = url;
          community.communityPicture = url;
        } else {
          const err = await picRes.json().catch(() => ({}));
          alert('Failed to save picture: ' + (err.error || picRes.status));
        }
      });
    }

    const btn = document.getElementById('community-join-leave-btn');
    if (btn) {
      if (isAdmin) {
        btn.textContent = 'Update';
        btn.className = 'join-leave-btn update-btn';

        const editModal    = document.getElementById('edit-community-modal');
        const editClose    = document.getElementById('edit-community-close');
        const editDescInput = document.getElementById('edit-community-desc-input');
        const editTagsInput = document.getElementById('edit-community-tags-input');
        const editMsg      = document.getElementById('edit-community-message');

        initTagBubbles('edit-community-tags-container', 'edit-community-tags-input');

        function openEditModal() {
          editDescInput.value = community.description || '';
          populateTagBubbles('edit-community-tags-container', 'edit-community-tags-input', community.tags || []);
          editTagsInput.value = '';
          editMsg.style.display = 'none';
          editMsg.className = 'profile-message';
          editModal.classList.add('active');
          editModal.setAttribute('aria-hidden', 'false');
        }

        function closeEditModal() {
          editModal.classList.remove('active');
          editModal.setAttribute('aria-hidden', 'true');
        }

        btn.addEventListener('click', openEditModal);
        editClose.addEventListener('click', closeEditModal);
        editModal.addEventListener('click', e => { if (e.target === editModal) closeEditModal(); });

        document.getElementById('edit-community-submit').addEventListener('click', async () => {
          editMsg.style.display = 'none';
          editMsg.className = 'profile-message';

          const description = editDescInput.value.trim();
          const tags = getTagsFrom('edit-community-tags-container');

          try {
            const res = await fetch(`/api/community/${community.communityId}/update`, {
              method: 'PATCH',
              headers: { 'Content-Type': 'application/json', ...headers },
              body: JSON.stringify({ description, tags })
            });

            if (res.ok) {
              editMsg.textContent = 'Community updated successfully.';
              editMsg.classList.add('success');
              editMsg.style.display = 'block';

              const descEl = document.getElementById('community-description');
              if (descEl && description) descEl.textContent = description;
              community.description = description;

              const tagsEl = document.getElementById('community-tags');
              if (tagsEl) tagsEl.innerHTML = tags.map(t => `<span class="community-tag">#${t}</span>`).join('');
              community.tags = tags;
            } else {
              editMsg.textContent = 'Failed to update community. Please try again.';
              editMsg.classList.add('error');
              editMsg.style.display = 'block';
            }
          } catch {
            editMsg.textContent = 'Something went wrong. Please try again.';
            editMsg.classList.add('error');
            editMsg.style.display = 'block';
          }
        });
      } else if (community.communityId) {
        btn.textContent = isMember ? 'Leave' : 'Join';
        btn.className = 'join-leave-btn ' + (isMember ? 'leave-btn' : 'join-btn');

        btn.addEventListener('click', async () => {
          const leaving = btn.classList.contains('leave-btn');
          const res = await fetch(`/api/community/${community.communityId}/${leaving ? 'leave' : 'join'}`, {
            method: leaving ? 'DELETE' : 'POST',
            headers
          });
          if (res.ok) {
            const isNowMember = !leaving;
            btn.textContent = isNowMember ? 'Leave' : 'Join';
            btn.className = 'join-leave-btn ' + (isNowMember ? 'leave-btn' : 'join-btn');
            const count = document.getElementById('community-member-count');
            if (count) count.textContent = parseInt(count.textContent) + (isNowMember ? 1 : -1);
          }
        });
      }
    }
  }

  function formatDate(iso) {
    const d = new Date(iso);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      + ' · '
      + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
  }

  function renderCommunityPosts(posts) {
    const section = document.querySelector('.community-posts-section');
    const placeholder = document.getElementById('community-posts-placeholder');
    if (!section) return;

    if (!posts || posts.length === 0) {
      if (placeholder) placeholder.style.display = 'block';
      return;
    }

    if (placeholder) placeholder.style.display = 'none';

    posts.forEach(post => {
      const card = document.createElement('div');
      card.className = 'community-post-card';
      card.innerHTML = `
        <div class="community-post-header">
          <span class="community-post-username">u/${post.authorUsername}</span>
          <span class="community-post-date">${formatDate(post.createdAt)}</span>
        </div>
        ${post.title ? `<p class="community-post-title">${post.title}</p>` : ''}
        <p class="community-post-body">${post.contentText}</p>
      `;
      section.appendChild(card);
    });
  }

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

  // fetch community, membership, and trending tags in parallel
  Promise.all([
    fetch('/api/community/' + communityName, { headers })
      .then(r => r.ok ? r.json() : null),
    token
      ? fetch('/api/community/my-communities', { headers }).then(r => r.ok ? r.json() : [])
      : Promise.resolve([]),
    fetch('/api/community/trending-tags').then(r => r.ok ? r.json() : [])
  ]).then(([community, myCommunities, trendingTags]) => {
    renderTrending(trendingTags);
    if (!community) throw new Error();
    sessionStorage.removeItem('communityDetail');
    const isMember = myCommunities.some(c => c.communityId === community.communityId);
    render(community, isMember);

    return fetch(`/api/posts/community/${community.communityId}`, { headers });
  }).then(res => res.ok ? res.json() : [])
    .then(renderCommunityPosts)
    .catch(() => {
      const raw = sessionStorage.getItem('communityDetail');
      if (!raw) return;
      sessionStorage.removeItem('communityDetail');
      try { render(JSON.parse(raw), false); } catch {}
    });
})();
