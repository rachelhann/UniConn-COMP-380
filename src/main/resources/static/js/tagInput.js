// Reusable tag bubble input system.
// initTagBubbles(containerId, inputId) — activates Enter-to-add, Backspace-to-remove behavior.
// getTagsFrom(containerId)            — returns current tag array (used before form submit).
// clearTagBubbles / populateTagBubbles — used by modals that reset or pre-fill tags.
function initTagBubbles(containerId, inputId) {
  const container = document.getElementById(containerId);
  const input = document.getElementById(inputId);
  if (!container || !input) return;

  input.addEventListener('keydown', e => {
    if (e.key === 'Backspace' && input.value === '') {
      const bubbles = container.querySelectorAll('.tag-bubble');
      if (bubbles.length > 0) bubbles[bubbles.length - 1].remove();
      return;
    }
    if (e.key !== 'Enter') return;
    e.preventDefault();
    const val = input.value.trim();
    if (!val) return;
    if (getTagsFrom(containerId).length >= 5) return;
    if (getTagsFrom(containerId).includes(val)) return;
    _addTagBubble(container, input, val);
    input.value = '';
  });

  container.addEventListener('click', () => input.focus());
}

function _addTagBubble(container, input, val) {
  const bubble = document.createElement('span');
  bubble.className = 'tag-bubble';
  bubble.dataset.tag = val;

  const label = document.createElement('span');
  label.textContent = '#' + val;

  const remove = document.createElement('button');
  remove.type = 'button';
  remove.className = 'tag-bubble-remove';
  remove.setAttribute('aria-label', 'Remove');
  remove.textContent = '×';
  remove.addEventListener('click', e => { e.stopPropagation(); bubble.remove(); });

  bubble.appendChild(label);
  bubble.appendChild(remove);
  container.insertBefore(bubble, input);
}

function getTagsFrom(containerId) {
  const container = document.getElementById(containerId);
  if (!container) return [];
  return Array.from(container.querySelectorAll('.tag-bubble')).map(b => b.dataset.tag);
}

function clearTagBubbles(containerId) {
  const container = document.getElementById(containerId);
  if (!container) return;
  container.querySelectorAll('.tag-bubble').forEach(b => b.remove());
}

function populateTagBubbles(containerId, inputId, tags) {
  clearTagBubbles(containerId);
  const container = document.getElementById(containerId);
  const input = document.getElementById(inputId);
  if (!container || !input || !Array.isArray(tags)) return;
  tags.forEach(t => _addTagBubble(container, input, t));
}
