// Handles the Edit Profile modal: submits name/bio updates and refreshes the bio section in place.
// Loaded on profile.html only.
const editNameInput    = document.getElementById('edit-name-input');
const editBioInput     = document.getElementById('edit-bio-input');
const editMsg          = document.getElementById('edit-profile-message');

initModal({
  modalId:  'edit-profile-modal',
  toggleId: 'edit-profile-toggle',
  closeId:  'edit-profile-close',
  onOpen() {
    editMsg.style.display = 'none';
    editMsg.className = 'profile-message';
  },
  onClose() {}
});

document.getElementById('edit-profile-submit').addEventListener('click', async () => {
  editMsg.style.display = 'none';
  editMsg.className = 'profile-message';

  const body = {
    name:    editNameInput.value.trim(),
    userBio: editBioInput.value.trim()
  };

  try {
    const res = await fetch('/api/profile/update', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + localStorage.getItem('token') },
      body: JSON.stringify(body)
    });

    if (res.ok) {
      editMsg.textContent = 'Profile updated successfully.';
      editMsg.classList.add('success');
      editMsg.style.display = 'block';

      const fullnameEl = document.getElementById('profile-fullname');
      if (fullnameEl) fullnameEl.textContent = body.name;

      const bioSection = document.querySelector('.profile-bio-section');
      bioSection.innerHTML = '';
      if (body.userBio) {
        const bioEl = document.createElement('p');
        bioEl.className = 'profile-bio';
        bioEl.textContent = body.userBio;
        bioSection.appendChild(bioEl);
      } else {
        const emptyEl = document.createElement('p');
        emptyEl.className = 'profile-bio-empty';
        emptyEl.textContent = 'No bio yet.';
        bioSection.appendChild(emptyEl);
      }
    } else {
      editMsg.textContent = 'Failed to update profile. Please try again.';
      editMsg.classList.add('error');
      editMsg.style.display = 'block';
    }
  } catch {
    editMsg.textContent = 'Something went wrong. Please try again.';
    editMsg.classList.add('error');
    editMsg.style.display = 'block';
  }
});
