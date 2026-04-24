(function () {
  const container  = document.getElementById('profile-posts-container');
  const modal      = document.getElementById('post-view-modal');
  const modalBody  = document.getElementById('post-view-body');
  const modalDate  = document.getElementById('post-view-date');
  const modalClose = document.getElementById('post-view-close');
  if (!container) return;

  const fallbackUsername = localStorage.getItem('currentUsername') || '';

  function formatDate(iso) {
    const d = new Date(iso);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      + ' · '
      + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
  }

  const posts = JSON.parse(localStorage.getItem('myProfilePosts') || '[]');

  if (posts.length === 0) {
    container.innerHTML = '<p class="profile-posts-empty">No posts yet.</p>';
    return;
  }

  posts.forEach(post => {
    if (!post.username) post.username = fallbackUsername;
    const card = document.createElement('div');
    card.className = 'profile-post-card';
    card.innerHTML = `
      <span class="profile-post-username">u/${post.username}</span>
      <p class="profile-post-body">${post.body}</p>
      <span class="profile-post-date">${formatDate(post.createdAt)}</span>
    `;
    card.addEventListener('click', () => {
      modalBody.textContent = post.body;
      modalDate.textContent = 'u/' + post.username + ' · ' + formatDate(post.createdAt);
      modal.classList.add('active');
    });
    container.appendChild(card);
  });

  if (modalClose) modalClose.addEventListener('click', () => modal.classList.remove('active'));
  if (modal) modal.addEventListener('click', e => { if (e.target === modal) modal.classList.remove('active'); });
})();
