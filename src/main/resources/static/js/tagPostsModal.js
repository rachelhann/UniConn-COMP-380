// Injects and manages the tag posts modal. Loaded on every page.
// window.openTagPostsModal(tag) is called by trending tags, post tags, and community tags.
(function () {
  const MODAL_HTML = `
    <div id="tag-posts-modal" class="search-modal-overlay" aria-hidden="true">
      <div class="search-modal">
        <div class="header-right">
          <h3 class="search-modal-title" id="tag-posts-modal-title">#tag</h3>
        </div>
        <button class="search-modal-close" id="tag-posts-modal-close" aria-label="Close">&times;</button>
        <div class="tag-modal-toolbar">
          <div class="tag-modal-filters">
            <button class="tag-filter-btn active" data-filter="all">All</button>
            <button class="tag-filter-btn" data-filter="communities">Communities</button>
            <button class="tag-filter-btn" data-filter="posts">Posts</button>
          </div>
        </div>
        <ul id="tag-posts-modal-list" class="search-results-list"></ul>
      </div>
    </div>
  `;

  let allPosts       = [];
  let allCommunities = null; // lazy-loaded, cached for the session
  let activeFilter   = 'all';
  let searchQuery    = '';
  let currentTag     = '';

  function fmt(iso) {
    return new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  }

  // Fetch all communities once and cache them
  async function loadCommunities() {
    if (allCommunities !== null) return allCommunities;
    const token   = localStorage.getItem('token');
    const headers = token ? { 'Authorization': 'Bearer ' + token } : {};
    try {
      const r = await fetch('/api/community/all', { headers });
      allCommunities = r.ok ? await r.json() : [];
    } catch {
      allCommunities = [];
    }
    return allCommunities;
  }

  function buildCommunityLi(c) {
    const li = document.createElement('li');
    li.className = 'search-result-card';
    li.style.cursor = 'pointer';
    li.addEventListener('click', () => { window.location.href = '/community/' + c.communityName; });
    const tagsHtml = Array.isArray(c.tags) && c.tags.length
      ? '<div style="display:flex;flex-wrap:wrap;gap:4px;margin-top:4px">'
        + c.tags.map(t => `<span class="post-card-tag" style="cursor:pointer" onclick="event.stopPropagation();openTagPostsModal('${t}')">#${t}</span>`).join('')
        + '</div>'
      : '';
    li.innerHTML = `
      <div class="src-card-row">
        <img src="${c.communityPicture || '/vector-logos/clubLogo.svg'}" alt="" class="src-card-icon">
        <div class="src-card-body">
          <div class="src-card-header">
            <span class="src-card-name">c/${c.communityName || ''}</span>
          </div>
          <span class="src-card-members">${c.memberCount ?? 0} members</span>
          ${c.description ? `<p class="src-card-desc">${c.description}</p>` : ''}
          ${tagsHtml}
        </div>
      </div>
    `;
    return li;
  }

  function buildPostLi(post) {
    const li = document.createElement('li');
    li.className = 'search-result-card';
    li.style.cursor = 'pointer';
    li.addEventListener('click', () => openPost(post));
    const communityPart = post.communityName
      ? `<a href="/community/${post.communityName}" class="post-username-link" onclick="event.stopPropagation()">c/${post.communityName}</a>`
      : null;
    const meta = [
      `<a href="/profile/${post.authorUsername}" class="post-username-link" onclick="event.stopPropagation()">u/${post.authorUsername}</a>`,
      communityPart,
      fmt(post.createdAt)
    ].filter(Boolean).join(' · ');
    const tagsHtml = Array.isArray(post.tags) && post.tags.length
      ? '<div style="display:flex;flex-wrap:wrap;gap:4px;margin-top:6px">'
        + post.tags.map(t => `<span class="post-card-tag" style="cursor:pointer" onclick="event.stopPropagation();openTagPostsModal('${t}')">#${t}</span>`).join('')
        + '</div>'
      : '';
    li.innerHTML = `
      <span class="src-card-members">${meta}</span>
      ${post.title ? `<p class="src-card-name" style="margin:4px 0 2px">${post.title}</p>` : ''}
      <p class="src-card-desc">${post.contentText}</p>
      ${tagsHtml}
    `;
    return li;
  }

  function sectionHeader(label) {
    const li = document.createElement('li');
    li.style.cssText = 'padding:8px 8px 2px;font-size:0.75em;font-weight:700;color:#888;letter-spacing:0.06em;text-transform:uppercase;list-style:none';
    li.textContent = label;
    return li;
  }

  function filterCommunities(communities) {
    const q = searchQuery.toLowerCase();
    return communities.filter(c =>
      Array.isArray(c.tags) && c.tags.some(t => t.toLowerCase() === currentTag.toLowerCase()) &&
      (!q || (c.communityName || '').toLowerCase().includes(q) || (c.description || '').toLowerCase().includes(q))
    );
  }

  function filterPosts(posts) {
    const q = searchQuery.toLowerCase();
    return q
      ? posts.filter(p =>
          (p.authorUsername || '').toLowerCase().includes(q) ||
          (p.title || '').toLowerCase().includes(q) ||
          (p.contentText || '').toLowerCase().includes(q))
      : posts;
  }

  function renderCommunityCards(communities) {
    const list = document.getElementById('tag-posts-modal-list');
    if (!list) return;
    list.innerHTML = '';
    const filtered = filterCommunities(communities);
    if (!filtered.length) {
      list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">No communities found.</li>';
      return;
    }
    filtered.forEach(c => list.appendChild(buildCommunityLi(c)));
  }

  function renderPostCards(posts) {
    const list = document.getElementById('tag-posts-modal-list');
    if (!list) return;
    list.innerHTML = '';
    const filtered = filterPosts(posts);
    if (!filtered.length) {
      list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">No posts found.</li>';
      return;
    }
    filtered.forEach(post => list.appendChild(buildPostLi(post)));
  }

  function applyFilters() {
    const list = document.getElementById('tag-posts-modal-list');
    if (!list) return;

    if (activeFilter === 'communities') {
      list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
      loadCommunities().then(renderCommunityCards);
    } else if (activeFilter === 'posts') {
      renderPostCards(allPosts);
    } else {
      // 'all' — communities section + posts section
      list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
      loadCommunities().then(communities => {
        list.innerHTML = '';
        const comms = filterCommunities(communities);
        const posts  = filterPosts(allPosts);
        if (!comms.length && !posts.length) {
          list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">No results found.</li>';
          return;
        }
        if (comms.length) {
          list.appendChild(sectionHeader('Communities'));
          comms.forEach(c => list.appendChild(buildCommunityLi(c)));
        }
        if (posts.length) {
          list.appendChild(sectionHeader('Posts'));
          posts.forEach(post => list.appendChild(buildPostLi(post)));
        }
      });
    }
  }

  function openPost(post) {
    sessionStorage.setItem('pendingPostModal', JSON.stringify(post));
    if (post.communityName) {
      window.location.href = '/community/' + post.communityName;
    } else {
      window.location.href = '/profile/' + post.authorUsername;
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    document.body.insertAdjacentHTML('beforeend', MODAL_HTML);

    const modal    = document.getElementById('tag-posts-modal');
    const closeBtn = document.getElementById('tag-posts-modal-close');

    function close() {
      modal.classList.remove('active');
      modal.setAttribute('aria-hidden', 'true');
    }

    closeBtn.addEventListener('click', close);
    modal.addEventListener('click', e => { if (e.target === modal) close(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') close(); });

    document.querySelectorAll('.tag-filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.tag-filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        activeFilter = btn.dataset.filter;
        applyFilters();
      });
    });

    // Global hashtag delegation — capture phase so it fires before card click handlers
    document.addEventListener('click', e => {
      const tagEl = e.target.closest('.mc-tag, .community-tag, .post-card-tag');
      if (!tagEl) return;
      e.stopPropagation();
      e.preventDefault();
      const tag = tagEl.textContent.replace(/^#/, '').trim();
      if (tag) openTagPostsModal(tag);
    }, true);
  });

  window.openTagPostsModal = function (tag) {
    const modal = document.getElementById('tag-posts-modal');
    const title = document.getElementById('tag-posts-modal-title');
    const list  = document.getElementById('tag-posts-modal-list');
    if (!modal) return;

    currentTag   = tag;
    activeFilter = 'all';
    searchQuery  = '';
    allPosts     = [];

    title.textContent = '#' + tag;
    list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Loading...</li>';
    document.querySelectorAll('.tag-filter-btn').forEach(b => {
      b.classList.toggle('active', b.dataset.filter === 'all');
    });

    modal.classList.add('active');
    modal.setAttribute('aria-hidden', 'false');

    const token   = localStorage.getItem('token');
    const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

    fetch('/api/posts/tag/' + encodeURIComponent(tag), { headers })
      .then(r => r.ok ? r.json() : [])
      .then(posts => { allPosts = posts; applyFilters(); })
      .catch(() => {
        list.innerHTML = '<li style="padding:12px 8px;color:#999;font-size:0.9em">Failed to load posts.</li>';
      });
  };
})();
