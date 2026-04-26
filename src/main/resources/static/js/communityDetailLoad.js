(function () {
  const communityName = window.location.pathname.split('/').pop();
  const token = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

  const fmt = s => s ? s.toLowerCase().replace(/_/g, ' ') : '';

  const currentUsername = localStorage.getItem('currentUsername') || '';

  function render(community, isMember) {
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

    // join/leave button
    const isAdmin = community.createdByUsername === currentUsername;
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
              method: 'PUT',
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

  // fetch community + membership in parallel
  Promise.all([
    fetch('/api/community/' + communityName, { headers })
      .then(r => r.ok ? r.json() : null),
    token
      ? fetch('/api/community/my-communities', { headers }).then(r => r.ok ? r.json() : [])
      : Promise.resolve([])
  ]).then(([community, myCommunities]) => {
    if (!community) throw new Error();
    sessionStorage.removeItem('communityDetail');
    const isMember = myCommunities.some(c => c.communityId === community.communityId);
    render(community, isMember);
  }).catch(() => {
    const raw = sessionStorage.getItem('communityDetail');
    if (!raw) return;
    sessionStorage.removeItem('communityDetail');
    try { render(JSON.parse(raw), false); } catch {}
  });
})();
