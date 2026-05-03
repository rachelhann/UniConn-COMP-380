// feedPagination.js — Owned by Abigail Artiga
// Infinite scroll for the main feed — loads page 1, 2, 3... on scroll
// Page 0 is loaded by userFeedLoad.js

(function () {
  const token = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};
  const pageSize = 20;

  let currentPage = 1;
  let isLoading = false;
  let hasMore = true;

  function loadNextPage() {
    if (isLoading || !hasMore) return;
    const userId = localStorage.getItem('currentUserId');
    if (!userId) return;

    isLoading = true;
    console.log(`[feedPagination] Loading page ${currentPage}...`);

    fetch(`/api/posts/feed/${userId}?page=${currentPage}&size=${pageSize}`, { headers })
      .then(r => r.ok ? r.json() : [])
      .then(posts => {
        if (!posts || posts.length === 0) {
          hasMore = false;
          console.log('[feedPagination] No more posts.');
          return;
        }

        const container = document.getElementById('feed-posts-list');
        if (!container) return;

        posts.forEach(post => container.appendChild(createPostCard(post)));
        currentPage++;
        console.log(`[feedPagination] Loaded ${posts.length} posts. Next page: ${currentPage}`);

        if (posts.length < pageSize) {
          hasMore = false;
          console.log('[feedPagination] Last page reached.');
        }
      })
      .catch(err => {
        console.error('[feedPagination] Error:', err);
        hasMore = false;
      })
      .finally(() => { isLoading = false; });
  }

  // Wait for page 0 to finish rendering before setting up observer
  window.addEventListener('load', function () {
    setTimeout(function () {
      const container = document.getElementById('feed-posts-list');
      if (!container) return;

      const sentinel = document.createElement('div');
      sentinel.id = 'feed-sentinel';
      sentinel.style.height = '20px';
      sentinel.style.background = 'transparent';
      container.insertAdjacentElement('afterend', sentinel);

      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            console.log('[feedPagination] Sentinel visible — loading next page');
            loadNextPage();
          }
        });
      }, { rootMargin: '400px' });

      observer.observe(sentinel);
      console.log('[feedPagination] Infinite scroll ready.');
    }, 1500); // wait 1.5s for page 0 to finish rendering
  });
})();