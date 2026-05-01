(function () {
  function applyPfp(url) {
    const img = document.querySelector('a[title="Profile"] img');
    if (!img) return;
    img.src = url;
    img.style.borderRadius = '50%';
    img.style.objectFit = 'cover';
    img.style.width = '32px';
    img.style.height = '32px';
    img.style.margin = '0';
  }

  const cached = localStorage.getItem('profilePicture');
  if (cached) {
    applyPfp(cached);
    return;
  }

  const token = localStorage.getItem('token');
  if (!token) return;

  fetch('/api/profile/me', { headers: { 'Authorization': 'Bearer ' + token } })
    .then(r => r.ok ? r.json() : null)
    .then(data => {
      if (data && data.profilePicture) {
        localStorage.setItem('profilePicture', data.profilePicture);
        applyPfp(data.profilePicture);
      }
    })
    .catch(() => {});
})();
