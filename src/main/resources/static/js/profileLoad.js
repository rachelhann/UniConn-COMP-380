(function () {
  const token = localStorage.getItem('token');
  if (!token) return;

  fetch('/api/profile/me', {
    headers: { 'Authorization': 'Bearer ' + token }
  })
    .then(res => {
      if (!res.ok) throw new Error('Not authenticated');
      return res.json();
    })
    .then(data => {
      // username
      const usernameEl = document.getElementById('profile-username');
      if (usernameEl) usernameEl.textContent = 'u/' + (data.username || '');
      if (data.username) localStorage.setItem('currentUsername', data.username);

      // Avatar
      const avatarEl = document.getElementById('profile-picture-img');
      if (avatarEl && data.profilePicture) avatarEl.src = data.profilePicture;

      // stats
      const followerEl = document.getElementById('follower-count');
      const followingEl = document.getElementById('following-count');
      const communityEl = document.getElementById('community-count');
      if (followerEl)  followerEl.textContent  = data.followerCount  ?? 0;
      if (followingEl) followingEl.textContent = data.followingCount ?? 0;
      if (communityEl) communityEl.textContent = data.communityCount ?? 0;

      // bio
      const bioSection = document.getElementById('profile-bio-section');
      if (bioSection) {
        bioSection.innerHTML = '';
        if (data.name) {
          const nameEl = document.createElement('span');
          nameEl.className = 'profile-name';
          nameEl.textContent = data.name;
          bioSection.appendChild(nameEl);
        }
        if (data.userBio) {
          const bioEl = document.createElement('p');
          bioEl.className = 'profile-bio';
          bioEl.textContent = data.userBio;
          bioSection.appendChild(bioEl);
        }
        if (!data.name && !data.userBio) {
          const emptyEl = document.createElement('p');
          emptyEl.className = 'profile-bio-empty';
          emptyEl.textContent = 'No bio yet.';
          bioSection.appendChild(emptyEl);
        }
      }

      // edit modal inputs 
      const nameInput = document.getElementById('edit-name-input');
      const bioInput  = document.getElementById('edit-bio-input');
      if (nameInput) nameInput.value = data.name    || '';
      if (bioInput)  bioInput.value  = data.userBio || '';
    })
    .catch(() => {});
})();
