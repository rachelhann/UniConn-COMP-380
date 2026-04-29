// Shared post card renderer — used by feed, profile, and user profile pages
// Requires: postCards.css, modals.css
// Depends on: post-view-overlay modal being present in the HTML

function formatPostDate(iso) {
  const d = new Date(iso);
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
    + ' · '
    + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
}

function authHeaders() {
  return { 'Authorization': 'Bearer ' + localStorage.getItem('token') };
}

function createPostCard(post, { onDelete } = {}) {
  const card = document.createElement('div');
  card.className = 'post-card';
  card.dataset.postId = post.postId;

  // meta
  const meta = document.createElement('div');
  meta.className = 'post-card-meta';
  meta.innerHTML = `<span class="post-card-author">u/${post.authorUsername}</span>`;
  if (post.communityName) {
    meta.innerHTML += `<span class="post-card-community">c/${post.communityName}</span>`;
  }
  card.appendChild(meta);

  // title
  if (post.title) {
    const title = document.createElement('p');
    title.className = 'post-card-title';
    title.textContent = post.title;
    card.appendChild(title);
  }

  // body preview
  const body = document.createElement('p');
  body.className = 'post-card-body';
  body.textContent = post.contentText;
  card.appendChild(body);

  // tags
  if (post.tags && post.tags.length > 0) {
    const tagsWrap = document.createElement('div');
    tagsWrap.className = 'post-card-tags';
    post.tags.forEach(tag => {
      const t = document.createElement('span');
      t.className = 'post-card-tag';
      t.textContent = '#' + tag;
      t.addEventListener('click', e => {
        e.stopPropagation();
        window.location.href = '/posts/tag/' + encodeURIComponent(tag);
      });
      tagsWrap.appendChild(t);
    });
    card.appendChild(tagsWrap);
  }

  // footer
  const footer = document.createElement('div');
  footer.className = 'post-card-footer';

  // like button
  const likeBtn = document.createElement('button');
  likeBtn.className = 'post-card-action';
  const likeImg = document.createElement('img');
  likeImg.src = post.likedByCurrentUser
    ? '/vector-logos/heartBlue.svg'
    : '/vector-logos/heartOutline.svg';
  likeImg.alt = 'Like';
  const likeCount = document.createElement('span');
  likeCount.textContent = post.likeCount;
  likeBtn.appendChild(likeImg);
  likeBtn.appendChild(likeCount);
  let liked = post.likedByCurrentUser;

  likeBtn.addEventListener('click', async e => {
    e.stopPropagation();
    try {
      const res = await fetch(`/api/posts/${post.postId}/like`, {
        method: liked ? 'DELETE' : 'POST',
        headers: authHeaders()
      });
      if (res.ok) {
        liked = !liked;
        likeImg.src = liked ? '/vector-logos/heartBlue.svg' : '/vector-logos/heartOutline.svg';
        likeCount.textContent = liked
          ? parseInt(likeCount.textContent) + 1
          : parseInt(likeCount.textContent) - 1;
      }
    } catch {}
  });
  footer.appendChild(likeBtn);

  // comment count
  const commentBtn = document.createElement('button');
  commentBtn.className = 'post-card-action';
  commentBtn.innerHTML = `<span>💬</span><span>${post.commentCount}</span>`;
  commentBtn.addEventListener('click', e => {
    e.stopPropagation();
    openPostViewModal(post);
  });
  footer.appendChild(commentBtn);

  // date
  const date = document.createElement('span');
  date.className = 'post-card-date';
  date.textContent = formatPostDate(post.createdAt);
  footer.appendChild(date);

  // delete
  if (post.canDelete) {
    const delBtn = document.createElement('button');
    delBtn.className = 'post-card-action post-card-delete';
    delBtn.innerHTML = `<img src="/vector-logos/deleteTrashBin.svg" alt="Delete">`;
    delBtn.addEventListener('click', async e => {
      e.stopPropagation();
      if (!confirm('Delete this post?')) return;
      try {
        const res = await fetch(`/api/posts/${post.postId}`, {
          method: 'DELETE',
          headers: authHeaders()
        });
        if (res.ok) {
          card.remove();
          if (onDelete) onDelete(post.postId);
        }
      } catch {}
    });
    footer.appendChild(delBtn);
  }

  card.appendChild(footer);
  card.addEventListener('click', () => openPostViewModal(post));
  return card;
}

function renderPostList(posts, containerId) {
  const container = document.getElementById(containerId);
  if (!container) return;
  if (!posts || posts.length === 0) {
    container.innerHTML = '<p style="color:#999;font-size:0.9em;padding:16px">No posts yet.</p>';
    return;
  }
  container.innerHTML = '';
  posts.forEach(post => container.appendChild(createPostCard(post)));
}

// ── Post view modal (shared) ──────────────────────────────────────
function openPostViewModal(post) {
  const overlay      = document.getElementById('post-view-overlay');
  const modalMeta    = document.getElementById('post-view-meta');
  const modalTitle   = document.getElementById('post-view-title');
  const modalContent = document.getElementById('post-view-content');
  const modalTags    = document.getElementById('post-view-tags');
  const modalFooter  = document.getElementById('post-view-footer');
  const commentInput = document.getElementById('post-view-comment-input');
  const commentsList = document.getElementById('post-view-comments-list');
  if (!overlay) return;

  // meta
  modalMeta.innerHTML = `<span style="font-weight:600;color:#333">u/${post.authorUsername}</span>`;
  if (post.communityName) {
    modalMeta.innerHTML += `<span class="post-view-community">c/${post.communityName}</span>`;
  }
  modalMeta.innerHTML += `<span style="margin-left:auto;font-size:0.78em;color:#aaa">${formatPostDate(post.createdAt)}</span>`;

  // title
  if (post.title) {
    modalTitle.textContent = post.title;
    modalTitle.style.display = '';
  } else {
    modalTitle.style.display = 'none';
  }

  // content + tags
  modalContent.textContent = post.contentText;
  modalTags.innerHTML = '';
  (post.tags || []).forEach(tag => {
    const t = document.createElement('span');
    t.className = 'post-card-tag';
    t.textContent = '#' + tag;
    t.addEventListener('click', () => {
      window.location.href = '/posts/tag/' + encodeURIComponent(tag);
    });
    modalTags.appendChild(t);
  });

  // footer
  modalFooter.innerHTML = '';
  let activeLiked = post.likedByCurrentUser;
  let activeLikeCount = post.likeCount;

  const likeBtn = document.createElement('button');
  likeBtn.className = 'post-card-action';
  const likeImg = document.createElement('img');
  likeImg.src = activeLiked ? '/vector-logos/heartBlue.svg' : '/vector-logos/heartOutline.svg';
  likeImg.alt = 'Like';
  const likeCountSpan = document.createElement('span');
  likeCountSpan.textContent = activeLikeCount;
  likeBtn.appendChild(likeImg);
  likeBtn.appendChild(likeCountSpan);
  likeBtn.addEventListener('click', async () => {
    try {
      const res = await fetch(`/api/posts/${post.postId}/like`, {
        method: activeLiked ? 'DELETE' : 'POST',
        headers: authHeaders()
      });
      if (res.ok) {
        activeLiked = !activeLiked;
        likeImg.src = activeLiked ? '/vector-logos/heartBlue.svg' : '/vector-logos/heartOutline.svg';
        activeLikeCount = activeLiked ? activeLikeCount + 1 : activeLikeCount - 1;
        likeCountSpan.textContent = activeLikeCount;
      }
    } catch {}
  });
  modalFooter.appendChild(likeBtn);

  const commentCount = document.createElement('span');
  commentCount.className = 'post-card-action';
  commentCount.innerHTML = `<span>💬</span><span id="modal-comment-count">${post.commentCount}</span>`;
  modalFooter.appendChild(commentCount);

  if (post.canDelete) {
    const delBtn = document.createElement('button');
    delBtn.className = 'post-card-action post-card-delete';
    delBtn.style.marginLeft = 'auto';
    delBtn.innerHTML = `<img src="/vector-logos/deleteTrashBin.svg" alt="Delete">`;
    delBtn.addEventListener('click', async () => {
      if (!confirm('Delete this post?')) return;
      try {
        const res = await fetch(`/api/posts/${post.postId}`, {
          method: 'DELETE', headers: authHeaders()
        });
        if (res.ok) {
          closePostViewModal();
          document.querySelector(`[data-post-id="${post.postId}"]`)?.remove();
        }
      } catch {}
    });
    modalFooter.appendChild(delBtn);
  }

  // comments
  if (commentInput) commentInput.value = '';
  if (commentsList) {
    commentsList.innerHTML = '<p class="comment-empty">Loading comments...</p>';
    loadComments(post.postId, commentsList);
  }

  overlay._activePostId = post.postId;
  overlay.classList.add('active');
  overlay.setAttribute('aria-hidden', 'false');
}

function closePostViewModal() {
  const overlay = document.getElementById('post-view-overlay');
  if (overlay) {
    overlay.classList.remove('active');
    overlay.setAttribute('aria-hidden', 'true');
    overlay._activePostId = null;
  }
}

function loadComments(postId, listEl) {
  fetch(`/api/posts/${postId}/comments`, { headers: authHeaders() })
    .then(r => r.ok ? r.json() : [])
    .then(comments => {
      listEl.innerHTML = '';
      if (!comments || comments.length === 0) {
        listEl.innerHTML = '<p class="comment-empty">No comments yet. Be the first!</p>';
        return;
      }
      comments.forEach(c => listEl.appendChild(createCommentEl(c)));
    })
    .catch(() => {
      listEl.innerHTML = '<p class="comment-empty">Could not load comments.</p>';
    });
}

function createCommentEl(c) {
  const el = document.createElement('div');
  el.className = 'comment-item';
  el.dataset.commentId = c.commentId;
  el.innerHTML = `
    <span class="comment-author">u/${c.authorUsername}</span>
    <span class="comment-date">${formatPostDate(c.createdAt)}</span>
    <p class="comment-text">${c.contentText}</p>
  `;
  const currentUsername = localStorage.getItem('currentUsername');
  if (c.authorUsername === currentUsername) {
    const delBtn = document.createElement('button');
    delBtn.className = 'comment-delete-btn';
    delBtn.innerHTML = `<img src="/vector-logos/deleteTrashBin.svg" alt="Delete">`;
    delBtn.addEventListener('click', async () => {
      try {
        const res = await fetch(`/api/posts/comments/${c.commentId}`, {
          method: 'DELETE', headers: authHeaders()
        });
        if (res.ok) {
          el.remove();
          const countEl = document.getElementById('modal-comment-count');
          if (countEl) countEl.textContent = parseInt(countEl.textContent) - 1;
        }
      } catch {}
    });
    el.appendChild(delBtn);
  }
  return el;
}

// ── Wire up modal close + comment submit (call once on page load) ──
function initPostViewModal() {
  const overlay      = document.getElementById('post-view-overlay');
  const closeBtn     = document.getElementById('post-view-close');
  const commentInput = document.getElementById('post-view-comment-input');
  const commentSubmit = document.getElementById('post-view-comment-submit');
  const commentsList = document.getElementById('post-view-comments-list');
  if (!overlay) return;

  closeBtn?.addEventListener('click', closePostViewModal);
  overlay.addEventListener('click', e => { if (e.target === overlay) closePostViewModal(); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closePostViewModal(); });

  commentSubmit?.addEventListener('click', async () => {
    const text = commentInput?.value.trim();
    const postId = overlay._activePostId;
    if (!text || !postId) return;
    try {
      const res = await fetch('/api/posts/comments', {
        method: 'POST',
        headers: { ...authHeaders(), 'Content-Type': 'application/json' },
        body: JSON.stringify({ postId, contentText: text })
      });
      if (res.ok) {
        const newComment = await res.json();
        commentInput.value = '';
        if (commentsList.querySelector('.comment-empty')) commentsList.innerHTML = '';
        commentsList.appendChild(createCommentEl(newComment));
        const countEl = document.getElementById('modal-comment-count');
        if (countEl) countEl.textContent = parseInt(countEl.textContent) + 1;
      }
    } catch {}
  });
}