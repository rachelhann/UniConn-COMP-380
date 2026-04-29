(function () {
  const token  = localStorage.getItem('token');
  const userId = localStorage.getItem('currentUserId');
  if (!token || !userId) return;

  initPostViewModal();

  fetch(`/api/posts/profile/${userId}`, {
    headers: { 'Authorization': 'Bearer ' + token }
  })
    .then(res => res.ok ? res.json() : [])
    .then(posts => renderPostList(posts, 'profile-posts-container'))
    .catch(() => {
      const c = document.getElementById('profile-posts-container');
      if (c) c.innerHTML = '<p style="color:#999;font-size:0.9em;padding:16px">Could not load posts.</p>';
    });
})();