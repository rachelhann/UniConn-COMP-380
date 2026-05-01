// handles create community modal: field validation, tag input, and form submission.
// loaded on all pages that include the create community-modal on sidenav
const communityNameInput     = document.getElementById('community-name-input');
const communityDescInput     = document.getElementById('community-desc-input');
const communityCategoryInput = document.getElementById('community-category-input');

// init modal: reset fields when opened
initModal({
  modalId:  'create-community-modal',
  toggleId: 'create-community-toggle',
  closeId:  'create-community-close',
  onOpen() {
    communityNameInput.value     = '';
    communityDescInput.value     = '';
    communityCategoryInput.value = '';
    clearTagBubbles('community-tags-container');
    communityNameInput.classList.remove('input-error');
    communityDescInput.classList.remove('input-error');
    communityCategoryInput.classList.remove('input-error');
  }
});

document.getElementById('create-community-submit').addEventListener('click', async () => {
  // validate required fields before sending to backend
  if (communityNameInput.value.trim() === '') {
    communityNameInput.classList.add('input-error');
    communityNameInput.focus();
    return;
  }
  if (communityDescInput.value.trim() === '') {
    communityDescInput.classList.add('input-error');
    communityDescInput.focus();
    return;
  }
  if (communityCategoryInput.value === '') {
    communityCategoryInput.classList.add('input-error');
    return;
  }

  const tags = getTagsFrom('community-tags-container');

  try {
    const response = await fetch('/api/community/create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + localStorage.getItem('token') // JWT required
      },
      // send communityDTYO fields: name, description, category enum value, tags array
      body: JSON.stringify({
        communityName: communityNameInput.value.trim(),
        description:   communityDescInput.value.trim(),
        category:      communityCategoryInput.value, // matches CommunityCategory enum (e.g. "ACADEMICS")
        tags
      })
    });

    if (response.ok) {
      const community = await response.json();
      sessionStorage.setItem('communityDetail', JSON.stringify(community));

      const existing = JSON.parse(localStorage.getItem('myCommunities') || '[]');
      if (!existing.some(c => c.communityId === community.communityId)) {
        existing.push(community);
        localStorage.setItem('myCommunities', JSON.stringify(existing));
      }

      window.location.href = '/community/' + community.communityName;
    } else {
      let msg = 'Failed to create community.';
      try {
        const data = await response.json();
        msg = data.error || msg;
      } catch {}
      alert(`${response.status}: ${msg}`);
    }
  } catch {
    alert('Something went wrong. Please try again.');
  }
});

// clear error highlight as soon as the user corrects a field
communityNameInput.addEventListener('input', () => communityNameInput.classList.remove('input-error'));
communityDescInput.addEventListener('input', () => communityDescInput.classList.remove('input-error'));
communityCategoryInput.addEventListener('change', () => communityCategoryInput.classList.remove('input-error'));

initTagBubbles('community-tags-container', 'community-tags-input');
