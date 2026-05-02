// handles the create post modal: with destination option (profile vs community),
// includes community dropdown, optional tag input, and form submission.
// loaded on all pages that include the create-post-modal in sidenav
const titleInput           = document.getElementById('create-post-title-input');
const bodyInput            = document.getElementById('create-post-body-input');
const destinationBtn       = document.getElementById('create-post-destination-btn');
const destinationList      = document.getElementById('create-post-destination-list');
const communitySection     = document.getElementById('create-post-community-section');
const communityList        = document.getElementById('create-post-community-list');
const communityBtn         = document.getElementById('create-post-community-btn');
const postTagSection       = document.getElementById('create-post-tags-section');

let postTagsInitialized = false;

// tracks whether post goes to profile or community
let postDestination    = null;
// tracks selected communitys ID (null if posting to profile)
let selectedCommunityId = null;
// giphy
let selectedGifUrl     = null;

// fetches user's communities and populates community dropdown
async function loadCommunities() {
  communityList.innerHTML = '<li class="create-post-community-empty">Loading...</li>';
  try {
    const res = await fetch('/api/community/my-communities', {
      headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') }
    });
    if (!res.ok) throw new Error();
    const communities = await res.json();

    if (communities.length === 0) {
      communityList.innerHTML = '<li class="create-post-community-empty">No communities available</li>';
      return;
    }

    communityList.innerHTML = '';
    communities.forEach(c => {
      const li = document.createElement('li');
      li.className = 'create-post-community-item';
      li.textContent = 'c/' + c.communityName;
      li.addEventListener('click', () => {
        selectedCommunityId = c.communityId;
        communityBtn.innerHTML = 'c/' + c.communityName + ' <span class="create-post-arrow">&#9662;</span>';
        communityBtn.classList.remove('input-error');
        communityList.classList.remove('open');
      });
      communityList.appendChild(li);
    });
  } catch {
    const local = JSON.parse(localStorage.getItem('myCommunities') || '[]');
    if (local.length === 0) {
      communityList.innerHTML = '<li class="create-post-community-empty">No communities available</li>';
    } else {
      communityList.innerHTML = '';
      local.forEach(c => {
        const li = document.createElement('li');
        li.className = 'create-post-community-item';
        li.textContent = 'c/' + c.communityName;
        li.addEventListener('click', () => {
          selectedCommunityId = c.communityId;
          communityBtn.innerHTML = 'c/' + c.communityName + ' <span class="create-post-arrow">&#9662;</span>';
          communityBtn.classList.remove('input-error');
          communityList.classList.remove('open');
        });
        communityList.appendChild(li);
      });
    }
  }
}

// init modal: reset all fields when opened, close dropdowns when closed
initModal({
  modalId:  'create-post-modal',
  toggleId: 'add-post-toggle',
  closeId:  'create-post-close',
  onOpen() {
    if (!postTagsInitialized && postTagSection) {
      initTagBubbles('create-post-tags-container', 'create-post-tags-input');
      postTagsInitialized = true;
    }
	titleInput.value = '';
	bodyInput.value  = '';
	postDestination  = null;
	selectedCommunityId = null;
	selectedGifUrl   = null;
	const postGifPreview = document.getElementById('post-gif-preview');
	if (postGifPreview) postGifPreview.innerHTML = '';
    destinationBtn.innerHTML = 'Post in... <span class="create-post-arrow">&#9662;</span>';
    communityBtn.innerHTML = 'Select Community <span class="create-post-arrow">&#9662;</span>';
    destinationList.classList.remove('open');
    communityList.classList.remove('open');
    communitySection.style.display = 'none';
    if (postTagSection) { postTagSection.style.display = 'none'; clearTagBubbles('create-post-tags-container'); }
    destinationBtn.classList.remove('input-error');
    communityBtn.classList.remove('input-error');
    titleInput.classList.remove('input-error');
    titleInput.closest('.create-post-title-wrap').style.display = ''; // show title on reset
    loadCommunities(); // refresh community list each time modal opens
  },
  onClose() {
    destinationList.classList.remove('open');
    communityList.classList.remove('open');
  }
});

// "Post in..." dropdown 
destinationBtn.addEventListener('click', () => {
  destinationList.classList.toggle('open');
  communityList.classList.remove('open'); // close community list if open
});

// post in user profile — title hidden, tags shown
document.getElementById('destination-profile').addEventListener('click', () => {
  postDestination     = 'profile';
  selectedCommunityId = null;
  destinationBtn.innerHTML = 'My Profile <span class="create-post-arrow">&#9662;</span>';
  destinationBtn.classList.remove('input-error');
  destinationList.classList.remove('open');
  communitySection.style.display = 'none';
  if (postTagSection) { postTagSection.style.display = ''; clearTagBubbles('create-post-tags-container'); }
  titleInput.value = '';
  titleInput.classList.remove('input-error');
  titleInput.closest('.create-post-title-wrap').style.display = 'none';
});

// post to community -> show community picker, title, and tag input
document.getElementById('destination-community').addEventListener('click', () => {
  postDestination = 'community';
  destinationBtn.innerHTML = 'Community <span class="create-post-arrow">&#9662;</span>';
  destinationBtn.classList.remove('input-error');
  destinationList.classList.remove('open');
  communitySection.style.display = 'block';
  if (postTagSection) postTagSection.style.display = '';
  titleInput.closest('.create-post-title-wrap').style.display = '';
});

communityBtn.addEventListener('click', () => communityList.classList.toggle('open'));

document.getElementById('create-post-submit').addEventListener('click', async () => {
  if (postDestination === 'community' && titleInput.value.trim() === '') {
    titleInput.classList.add('input-error');
    titleInput.focus();
    return;
  }
  if (bodyInput.value.trim() === '') {
    bodyInput.classList.add('input-error');
    bodyInput.focus();
    return;
  }
  if (postDestination === null) {
    destinationBtn.classList.add('input-error');
    return;
  }
  if (postDestination === 'community' && selectedCommunityId === null) {
    communityBtn.classList.add('input-error');
    return;
  }

  const body = {
    contentText: bodyInput.value.trim(),
    title:       postDestination === 'community' ? titleInput.value.trim() : null,
    communityId: postDestination === 'community' ? selectedCommunityId   : null,
    tags:        getTagsFrom('create-post-tags-container'),
    gifUrl:      selectedGifUrl || null
  };

  try {
    const res = await fetch('/api/posts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + localStorage.getItem('token')
      },
      body: JSON.stringify(body)
    });

    if (res.ok) {
      const post = await res.json();
      if (postDestination === 'profile') {
        window.location.href = '/profile';
      } else {
        window.location.href = '/community/' + post.communityName;
      }
    } else {
      alert('Failed to create post. Please try again.');
    }
  } catch {
    alert('Something went wrong. Please try again.');
  }
});


titleInput.addEventListener('input', () => titleInput.classList.remove('input-error'));
bodyInput.addEventListener('input', () => bodyInput.classList.remove('input-error'));

// init GIF picker for create post modal
initGifPicker({
  triggerBtnId:       'post-gif-btn',
  previewContainerId: 'post-gif-preview',
  onSelect(url) {
    selectedGifUrl = url;
  }
});