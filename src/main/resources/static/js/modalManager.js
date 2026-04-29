/**
 * modal open and close behavior
 * @param {string} cfg.modalId   - overlay element
 * @param {string} cfg.toggleId  - opens modal
 * @param {string} cfg.closeId   - closes modal with x
 */

function initModal({ modalId, toggleId, closeId, onOpen, onClose }) {
  const modal    = document.getElementById(modalId);
  const toggle   = document.getElementById(toggleId);
  const closeBtn = document.getElementById(closeId);

  if (!modal || !toggle || !closeBtn) return; // ← add this

  function openModal() {
    modal.classList.add('active');
    modal.setAttribute('aria-hidden', 'false');
    if (onOpen) onOpen();
  }

  function closeModal() {
    modal.classList.remove('active');
    modal.setAttribute('aria-hidden', 'true');
    if (onClose) onClose();
  }

  toggle.addEventListener('click', e => { e.preventDefault(); openModal(); });
  closeBtn.addEventListener('click', closeModal);
  modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });
}
