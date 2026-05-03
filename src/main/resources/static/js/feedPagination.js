// feedPagination.js — Owned by Abigail Artiga
// Infinite scroll for the main feed — loads page 1, 2, 3... on scroll
// Page 0 is loaded by userFeedLoad.js

(function () {
  const token   = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};
  const pageSize = 20;

  let currentPage = 1;
  let isLoading   = false;
  let hasMore     = true;

  function loadNextPage() {
    if (isLoading || !hasMore) return;
    const userId = localStorage.getItem('currentUserId');
    if (!userId) return;

    isLoading = true;

    fetch(`/api/posts/feed/${userId}?page=${currentPage}&size=${pageSize}`, { headers })
      .then(r => r.ok ? r.json() : [])
      .then(posts => {
        if (!posts || posts.length === 0) {
          hasMore = false;
          const sentinel = document.getElementById('feed-sentinel');
          if (sentinel) sentinel.style.display = 'none';
          return;
        }
        const container = document.getElementById('feed-posts-list');
        if (!container) return;
        posts.forEach(post => container.appendChild(createPostCard(post)));
        currentPage++;
        if (posts.length < pageSize) {
          hasMore = false;
          const sentinel = document.getElementById('feed-sentinel');
          if (sentinel) sentinel.style.display = 'none';
        }
      })
      .catch(() => { hasMore = false; })
      .finally(() => { isLoading = false; });
  }

  window.addEventListener('load', function () {
    const container = document.getElementById('feed-posts-list');
    if (!container) return;

    const sentinel = document.createElement('div');
    sentinel.id = 'feed-sentinel';
    sentinel.style.height = '20px';
    container.insertAdjacentElement('afterend', sentinel);

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => { if (entry.isIntersecting) loadNextPage(); });
    }, { rootMargin: '300px' });

    observer.observe(sentinel);
  });
})();