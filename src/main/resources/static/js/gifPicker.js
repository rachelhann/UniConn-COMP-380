// GIF picker — shared across create post modal and comment input
// exposes: initGifPicker(config) 
// config: { triggerBtnId, previewContainerId, onSelect }

function initGifPicker({ triggerBtnId, previewContainerId, onSelect }) {

  // create picker dropdown and append to body
  const picker = document.createElement('div');
  picker.className = 'gif-picker';
  picker.innerHTML = `
    <input type="text" class="gif-search-input" placeholder="Search GIFs...">
    <div class="gif-grid"></div>
    <p class="gif-attribution">Powered by GIPHY</p>
  `;
  document.body.appendChild(picker);

  const triggerBtn      = document.getElementById(triggerBtnId);
  const previewContainer = document.getElementById(previewContainerId);
  const searchInput     = picker.querySelector('.gif-search-input');
  const gifGrid         = picker.querySelector('.gif-grid');

  let searchTimeout = null;
  let isOpen = false;

  // position picker near trigger button
  function positionPicker() {
    const rect = triggerBtn.getBoundingClientRect();
    picker.style.top  = (rect.bottom + window.scrollY + 6) + 'px';
    picker.style.left = (rect.left  + window.scrollX)      + 'px';
  }

  function openPicker() {
    positionPicker();
    picker.classList.add('open');
    isOpen = true;
    searchInput.value = '';
    gifGrid.innerHTML = '<p class="gif-empty">Type to search GIFs</p>';
    searchInput.focus();
  }

  function closePicker() {
    picker.classList.remove('open');
    isOpen = false;
  }

  triggerBtn.addEventListener('click', e => {
    e.stopPropagation();
    isOpen ? closePicker() : openPicker();
  });

  // close on outside click
  document.addEventListener('click', e => {
    if (isOpen && !picker.contains(e.target) && e.target !== triggerBtn) {
      closePicker();
    }
  });

  // search with debounce
  searchInput.addEventListener('input', () => {
    clearTimeout(searchTimeout);
    const q = searchInput.value.trim();
    if (!q) {
      gifGrid.innerHTML = '<p class="gif-empty">Type to search GIFs</p>';
      return;
    }
    gifGrid.innerHTML = '<p class="gif-empty">Searching...</p>';
    searchTimeout = setTimeout(() => fetchGifs(q), 400);
  });

  async function fetchGifs(query) {
      try {
        const res = await fetch(`/api/giphy/search?q=${encodeURIComponent(query)}&limit=40`, {
          headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') }
        });
        if (!res.ok) throw new Error();
        const text = await res.text();        // get raw string
        const parsed = JSON.parse(text);      // parse it once
        renderGifs(parsed.data || []);
      } catch {
        gifGrid.innerHTML = '<p class="gif-empty">Could not load GIFs.</p>';
      }
    }

  function renderGifs(gifs) {
    if (!gifs.length) {
      gifGrid.innerHTML = '<p class="gif-empty">No GIFs found.</p>';
      return;
    }
    gifGrid.innerHTML = '';
    gifs.forEach(gif => {
      const img = document.createElement('img');
      // fixed_height_small is lightweight and renders cleanly in grids
      img.src = gif.images.fixed_height_small.url;
      img.className = 'gif-grid-item';
      img.alt = gif.title || 'GIF';
      img.addEventListener('click', () => {
        // use fixed_height for the actual stored/displayed URL
        const url = gif.images.fixed_height.url;
        onSelect(url);
        showPreview(url, previewContainer);
        closePicker();
      });
      gifGrid.appendChild(img);
    });
  }

  function showPreview(url, container) {
    if (!container) return;
    container.innerHTML = `
      <div class="gif-preview-wrap">
        <img src="${url}" class="gif-preview-img" alt="Selected GIF">
        <button class="gif-remove-btn" title="Remove GIF">&times;</button>
      </div>
    `;
    container.querySelector('.gif-remove-btn').addEventListener('click', () => {
      container.innerHTML = '';
      onSelect(null);
    });
  }
}