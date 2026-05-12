// feedPagination.js — Owned by Abigail Artiga
(function () {
  const token = localStorage.getItem('token');
  const headers = token ? { 'Authorization': 'Bearer ' + token } : {};
  const pageSize = 20;

  let currentPage = 1;
  let isLoading = false;
  let hasMore = true;

  // ---------------------------------------------------------------
  // LOAD NEXT PAGE
  // ---------------------------------------------------------------
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
          showEndOfFeed();
          return;
        }

        const container = document.getElementById('feed-posts-list');
        if (!container) return;

        posts.forEach(post => container.appendChild(createPostCard(post)));
        currentPage++;

        if (posts.length < pageSize) {
          hasMore = false;
          showEndOfFeed();
        }
      })
      .catch(() => { hasMore = false; })
      .finally(() => { isLoading = false; });
  }

  // ---------------------------------------------------------------
  // END OF FEED INDICATOR
  // Appended OUTSIDE the scrollable container so mask-image
  // CSS fade doesn't hide it
  // ---------------------------------------------------------------
function showEndOfFeed() {
    const existing = document.getElementById('feed-end-msg');
    if (existing) return;
    const msg = document.createElement('div');
    msg.id = 'feed-end-msg';
    msg.className = 'feed-end-msg';
    msg.textContent = "You're all caught up ✓";
    const container = document.getElementById('feed-posts-list');
    if (container) container.appendChild(msg);
  }

  // ---------------------------------------------------------------
  // SCROLL LISTENER
  // Uses scroll event on the container directly — more reliable
  // than IntersectionObserver for fixed-height overflow-y:auto divs.
  // Triggers loadNextPage when user is within 150px of the bottom.
  // ---------------------------------------------------------------
  function setupScrollListener() {
    const container = document.getElementById('feed-posts-list');
    if (!container) return;

    container.addEventListener('scroll', function () {
      if (!hasMore || isLoading) return;

      const distanceFromBottom = container.scrollHeight - container.scrollTop - container.clientHeight;
      console.log(`[feedPagination] Distance from bottom: ${Math.round(distanceFromBottom)}px`);

      if (distanceFromBottom < 150) {
        loadNextPage();
      }
    });
  }

  // ---------------------------------------------------------------
  // WAIT FOR PAGE 0 TO FINISH PAINTING THEN SET UP SCROLL LISTENER
  // ---------------------------------------------------------------
  window.addEventListener('feedPage0Loaded', function () {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        setupScrollListener();
      });
    });
  });

})();