(function () {
  const token      = localStorage.getItem('token');
  const currentUserId = localStorage.getItem('currentUserId');
  const currentUsername = localStorage.getItem('currentUsername');

  // ── helpers ──────────────────────────────────────────────────────
  function formatDate(iso) {
    const d = new Date(iso);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      + ' · '
      + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
  }

  function authHeaders() {
    return { 'Authorization': 'Bearer ' + token };
  }

  // ── post card ─────────────────────────────────────────────────────
  function createPostCard(post) {
    const card = document.createElement('div');
    card.className = 'post-card';

    // meta row
    const meta = document.createElement('div');
    meta.className = 'post-card-meta';
    meta.innerHTML = `<span class="post-card-author">u/${post.authorUsername}</span>`;
    if (post.communityName) {
      meta.innerHTML += `<span class="post-card-community">c/${post.communityName}</span>`;
    }
    card.appendChild(meta);

    // title (community posts only)
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

    // footer: like, comments, date, delete
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
      const method = liked ? 'DELETE' : 'POST';
      try {
        const res = await fetch(`/api/posts/${post.postId}/like`, {
          method,
          headers: authHeaders()
        });
        if (res.ok) {
          liked = !liked;
          likeImg.src = liked
            ? '/vector-logos/heartBlue.svg'
            : '/vector-logos/heartOutline.svg';
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
      openPostModal(post);
    });
    footer.appendChild(commentBtn);

    // date
    const date = document.createElement('span');
    date.className = 'post-card-date';
    date.textContent = formatDate(post.createdAt);
    footer.appendChild(date);

    // delete button
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
          if (res.ok) card.remove();
        } catch {}
      });
      footer.appendChild(delBtn);
    }

    card.appendChild(footer);

    // click card -> open modal
    card.addEventListener('click', () => openPostModal(post));

    return card;
  }

  // ── render feed ───────────────────────────────────────────────────
  function renderFeed(posts) {
    const list = document.getElementById('feed-posts-list');
    if (!list) return;
    if (!posts || posts.length === 0) {
      list.innerHTML = '<p style="color:#999;font-size:0.9em;padding:16px">Nothing here yet. Follow people or join communities!</p>';
      return;
    }
    list.innerHTML = '';
    posts.forEach(post => list.appendChild(createPostCard(post)));
  }

  // ── post view modal ───────────────────────────────────────────────
  const overlay       = document.getElementById('post-view-overlay');
  const closeBtn      = document.getElementById('post-view-close');
  const modalMeta     = document.getElementById('post-view-meta');
  const modalTitle    = document.getElementById('post-view-title');
  const modalContent  = document.getElementById('post-view-content');
  const modalTags     = document.getElementById('post-view-tags');
  const modalFooter   = document.getElementById('post-view-footer');
  const commentInput  = document.getElementById('post-view-comment-input');
  const commentSubmit = document.getElementById('post-view-comment-submit');
  const commentsList  = document.getElementById('post-view-comments-list');

  let activePostId   = null;
  let activePostLiked = false;
  let activePostLikeCount = 0;

  function closeModal() {
    overlay.classList.remove('active');
    overlay.setAttribute('aria-hidden', 'true');
    activePostId = null;
    commentInput.value = '';
  }

  closeBtn.addEventListener('click', closeModal);
  overlay.addEventListener('click', e => { if (e.target === overlay) closeModal(); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

  function openPostModal(post) {
    activePostId = post.postId;
    activePostLiked = post.likedByCurrentUser;
    activePostLikeCount = post.likeCount;

    // meta
    modalMeta.innerHTML = `<span style="font-weight:600;color:#333">u/${post.authorUsername}</span>`;
    if (post.communityName) {
      modalMeta.innerHTML += `<span class="post-view-community">c/${post.communityName}</span>`;
    }
    modalMeta.innerHTML += `<span style="margin-left:auto;font-size:0.78em;color:#aaa">${formatDate(post.createdAt)}</span>`;

    // title
    if (post.title) {
      modalTitle.textContent = post.title;
      modalTitle.style.display = '';
    } else {
      modalTitle.style.display = 'none';
    }

    // content
    modalContent.textContent = post.contentText;

    // tags
    modalTags.innerHTML = '';
    if (post.tags && post.tags.length > 0) {
      post.tags.forEach(tag => {
        const t = document.createElement('span');
        t.className = 'post-card-tag';
        t.textContent = '#' + tag;
        t.style.cursor = 'pointer';
        t.addEventListener('click', () => {
          window.location.href = '/posts/tag/' + encodeURIComponent(tag);
        });
        modalTags.appendChild(t);
      });
    }

    // footer: like + comment count + delete
    modalFooter.innerHTML = '';

    const likeBtn = document.createElement('button');
    likeBtn.className = 'post-card-action';
    const likeImg = document.createElement('img');
    likeImg.src = activePostLiked
      ? '/vector-logos/heartBlue.svg'
      : '/vector-logos/heartOutline.svg';
    likeImg.alt = 'Like';
    const likeCountSpan = document.createElement('span');
    likeCountSpan.textContent = activePostLikeCount;
    likeBtn.appendChild(likeImg);
    likeBtn.appendChild(likeCountSpan);

    likeBtn.addEventListener('click', async () => {
      const method = activePostLiked ? 'DELETE' : 'POST';
      try {
        const res = await fetch(`/api/posts/${activePostId}/like`, {
          method, headers: authHeaders()
        });
        if (res.ok) {
          activePostLiked = !activePostLiked;
          likeImg.src = activePostLiked
            ? '/vector-logos/heartBlue.svg'
            : '/vector-logos/heartOutline.svg';
          activePostLikeCount = activePostLiked
            ? activePostLikeCount + 1
            : activePostLikeCount - 1;
          likeCountSpan.textContent = activePostLikeCount;
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
          const res = await fetch(`/api/posts/${activePostId}`, {
            method: 'DELETE', headers: authHeaders()
          });
          if (res.ok) {
            closeModal();
            document.querySelector(`[data-post-id="${activePostId}"]`)?.remove();
          }
        } catch {}
      });
      modalFooter.appendChild(delBtn);
    }

    // reset comments
    commentInput.value = '';
    commentsList.innerHTML = '<p class="comment-empty">Loading comments...</p>';

    overlay.classList.add('active');
    overlay.setAttribute('aria-hidden', 'false');

    loadComments(post.postId);
  }

  // ── comments ──────────────────────────────────────────────────────
  function loadComments(postId) {
    fetch(`/api/posts/${postId}/comments`, { headers: authHeaders() })
      .then(r => r.ok ? r.json() : [])
      .then(renderComments)
      .catch(() => {
        commentsList.innerHTML = '<p class="comment-empty">Could not load comments.</p>';
      });
  }

  function renderComments(comments) {
    commentsList.innerHTML = '';
    if (!comments || comments.length === 0) {
      commentsList.innerHTML = '<p class="comment-empty">No comments yet. Be the first!</p>';
      return;
    }
    comments.forEach(c => commentsList.appendChild(createCommentEl(c)));
  }

  function createCommentEl(c) {
    const el = document.createElement('div');
    el.className = 'comment-item';
    el.dataset.commentId = c.commentId;

    el.innerHTML = `
      <span class="comment-author">u/${c.authorUsername}</span>
      <span class="comment-date">${formatDate(c.createdAt)}</span>
      <p class="comment-text">${c.contentText}</p>
    `;

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

  commentSubmit.addEventListener('click', async () => {
    const text = commentInput.value.trim();
    if (!text || !activePostId) return;
    try {
      const res = await fetch('/api/posts/comments', {
        method: 'POST',
        headers: { ...authHeaders(), 'Content-Type': 'application/json' },
        body: JSON.stringify({ postId: activePostId, contentText: text })
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

  // ── load feed ─────────────────────────────────────────────────────
  if (!token || !currentUserId) {
    renderFeed([]);
    return;
  }

  fetch(`/api/posts/feed/${currentUserId}`, { headers: authHeaders() })
    .then(r => r.ok ? r.json() : [])
    .then(renderFeed)
    .catch(() => renderFeed([]));

  // ── trending tags ─────────────────────────────────────────────────
  fetch('/api/posts/trending', { headers: authHeaders() })
    .then(r => r.ok ? r.json() : [])
    .then(tags => {
      const list = document.getElementById('trending-tags-list');
      if (!list) return;
      if (!tags || tags.length === 0) {
        list.innerHTML = '<li class="trending-tag-empty">No trending topics yet.</li>';
        return;
      }
      list.innerHTML = '';
      tags.slice(0, 5).forEach((tag, i) => {
        const li = document.createElement('li');
        li.className = 'trending-tag-item';
        li.innerHTML = `<span class="trending-tag-rank">#${i + 1}</span><span class="trending-tag-name">${tag.tagName}</span>`;
        li.addEventListener('click', () => {
          window.location.href = '/communities?tag=' + encodeURIComponent(tag.tagName);
        });
        list.appendChild(li);
      });
    })
    .catch(() => {});
})();