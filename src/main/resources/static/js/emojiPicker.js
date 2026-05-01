/**
 * emojiPicker.js — UniConn emoji picker
 * - Scrollable emoji grid (fixed height, never overflows modal)
 * - Opens downward, left-aligned to the trigger button
 * - Works for #create-post-body-input and #post-view-comment-input
 */

(function () {
  const EMOJIS = [
    // Smileys & faces
    '😀','😂','😅','🤣','😊','😇','🙂','😉','😍','🥰',
    '😘','😎','🤩','🥳','😏','😒','😢','😭','😤','😠',
    '🤯','😳','😱','😴','🤔','🤫','🤭','😬','🙄','🤑',
    '🤠','🤥','🤧','🤨','🧐','😶','😑','😐','🙃','☺️',
    '😵','🤤','🥴','🤢','🤮','😷','🤒','🤕','👹','👺',
    '👽','👾','🤖','💋','👣','🧠','🦷','🦴','💀','👻','🤡','💩',

    // Hearts & hands
    '❤️','🧡','💛','💚','💙','💜','🖤','🤍','💔','💕',
    '👍','👎','👏','🙌','🤝','🙏','👀','💪','✌️','🤞',
    '🤙','🖐️','✋','🤚','👋','🤟','🤘','👌','🤏','🖖',
    '💅','🤳','💃','🕺','🧖','🧘','🤸','🤺', 

    // Common reactions
    '🔥','✨','💯','🎉','🎊','🥂','🚀','⭐','🌟','💫','🌈','☀️','🌙','❄️','🌊','🍀',

    // Animals
    '🐶','🐱','🐭','🐹','🐰','🦊','🐻','🐼','🐨','🐯',
    '🦁','🐮','🐷','🐸','🐵','🙈','🙉','🙊','🐔','🐧',
    '🐦','🦆','🦅','🦉','🦇','🐺','🐗','🐴','🦄','🐝',
    '🐛','🦋','🐌','🐞','🐜','🦟','🦗','🕷️','🦂','🐢',
    '🐍','🦎','🦕','🐙','🦑','🦐','🦞','🦀','🐡',
    '🐠','🐟','🐬','🐳','🐋','🦈','🐊','🐅','🐆',
    '🦓','🦍','🦧','🐘','🦛','🦏','🐪','🐫','🦒','🦘',
    '🐃','🐂','🐄','🐎','🐖','🐏','🐑','🦙','🐐',
    '🦌','🐕','🐩','🦮','🐈','🐓','🦃','🦚',
    '🦜','🦢','🕊️','🐇','🦝','🦨','🦡','🦦','🦥', '🦄',

    // Nature & weather
    '🌸','🌺','🌻','🌹','🥀','🌷','🌱','🌿','☘️','🍁',
    '🍂','🍃','🍄','🌾','💐','🌵','🎋','🎍','🌴',
    '🌲','🌳','🌏','🌍','🌎','🌑','🌒','🌓','🌔','🌕',
    '🌖','🌗','🌘','🌚','🌛','🌜','🌝','🌞',
    '⚡','☁️','⛅','🌧️','⛈️','🌩️','🌨️','☃️','⛄','💨','🌪️','🌫️',
    '💧','💦','☔','⛱️','🌋','🏔️','⛰️',

    // Food & drink
    '🍕','🍔','🌮','🍜','🍣','🍩','🍪','☕','🧋','🥤',
    '🍎','🍊','🍋','🍇','🍓','🍈','🍒','🍑','🥭',
    '🍍','🥥','🥝','🍅','🥑','🍆','🥔','🥕','🌽',
    '🌶️','🥒','🥬','🥦','🧄','🧅','🍞','🥐','🥖',
    '🥨','🧀','🍳','🧈','🥞','🧇','🥓','🥩','🍗',
    '🍖','🌭','🥪','🥙','🧆','🥚','🍱','🍘','🍙',
    '🍚','🍛','🍝','🍠','🍢','🍤','🍥','🥮','🍡',
    '🥟','🦪','🍦','🍧','🍨','🎂','🍰','🧁','🥧','🍫',
    '🍬','🍭','🍮','🧃','🥛','🍵','🍶','🍺','🍻',
    '🍷','🥃','🍸','🍹','🧉','🍾','🧊','🥄','🍴',

    // Sports & activities
    '⚽','🏀','🏈','⚾','🥎','🎾','🏐','🏉','🥏','🎱',
    '🏓','🏸','🏒','🥊','🥋','🎯','🛷','⛸️',
    '🥅','⛳','🏹','🎣','🤿','🎽','🎿','🏆','🥇','🥈','🥉',
    '🏅','🎖️','🎗️','🎫','🎟️','🎪','🤹','🎭',
    '🩰','🎨','🖼️','🎠','🎡','🎢','🎬','🎤','🎧',
    '🎼','🎹','🥁','🎷','🎺','🎸','🪕','🎻',

    // Transport & places
    '🚗','🚕','🚙','🚌','🚎','🏎️','🚓','🚑','🚒','🚐',
    '🚚','🚛','🚜','🛵','🏍️','🚲','🛴',
    '🚁','🚀','✈️','🛫','🛬','💺','🚂',
    '🚃','🚄','🚅','🚆','🚇','🚈','🚉','🚊','🚞','🚝',
    '⛽','🚧','⚓','⛵','🚤','🚢','🧭',
    '🏕️','🏖️','🏟️','🏛️','🧱',
    '🏠','🏡','🏢','🏥','🏦','🏨','🏪','🏫','🏬','🏭',

    // Study & tech
    '📚','📖','✏️','📝','💻','🖥️','📊','🏫','🎓','📅',

    // Objects
    '📱','💾','⌨️','💿','📀','📷','📸','📹','🎥',
    '📞','☎️','📺','📻','⏱️','⏲️','⏰','🕰️','⌛','⏳',
    '🔋','🔌','💡','🔦','🕯️','💰','💸','💳','🧾',
    '📈','📉','📌','📍','✂️','🔒','🔓','🔑',
    '🔨','⛏️','🛠️','⚔️','🛡️','🔧','🔩','⚙️','⚖️','🔗',
    '🧲','🧪','🧬','🔭','🔬','🩹','🩺','💊','💉',
    '🧹','🧺','🧻','🚿','🛁','🧴','🧷','🧼','🧽','🛒',
    '🚪','🛏️','🛋️','🎁','🎈','🎀','🎊','🎉','🧧',
    '🎆','🎇','🧨','🎃','🎄',
  ];

  const PICKER_W = 232;
  const PICKER_H = 200;

  const STYLES = `
    .uc-emoji-wrap {
      position: relative;
      display: flex;
      align-items: flex-start;
      gap: 4px;
      width: 100%;
    }
    .uc-emoji-wrap textarea {
      flex: 1 1 auto;
      min-width: 0;
    }
    .uc-emoji-trigger {
      flex: 0 0 auto;
      background: none;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      font-size: 1.2rem;
      cursor: pointer;
      padding: 5px 8px;
      line-height: 1;
      transition: background 0.15s;
      align-self: flex-start;
      margin-top: 2px;
      width: auto !important;
    }
    .uc-emoji-trigger:hover { background: #f0f0f0; }
    .uc-emoji-picker {
      position: fixed;
      z-index: 99999;
      background: #fff;
      border: 1.5px solid #e0e0e0;
      border-radius: 12px;
      box-shadow: 0 6px 24px rgba(0,0,0,0.15);
      padding: 8px;
      width: ${PICKER_W}px;
      max-height: ${PICKER_H}px;
      overflow-y: auto;
      overflow-x: hidden;
      display: none;
    }
    .uc-emoji-picker.open { display: block; }
    .uc-emoji-grid {
      display: grid;
      grid-template-columns: repeat(8, 1fr);
      gap: 2px;
    }
    .uc-emoji-btn {
      background: none;
      border: none;
      font-size: 1.3rem;
      cursor: pointer;
      padding: 4px 2px;
      border-radius: 5px;
      line-height: 1;
      transition: background 0.1s;
      text-align: center;
      width: 100%;
    }
    .uc-emoji-btn:hover { background: #f3f3f3; }
  `;

  function injectStyles() {
    if (document.getElementById('uc-emoji-styles')) return;
    const style = document.createElement('style');
    style.id = 'uc-emoji-styles';
    style.textContent = STYLES;
    document.head.appendChild(style);
  }

  function positionPicker(trigger, picker) {
    const r      = trigger.getBoundingClientRect();
    const margin = 8;
    let left = r.left;
    let top  = r.bottom + margin;
    if (top + PICKER_H > window.innerHeight - margin) {
      top = r.top - PICKER_H - margin;
    }
    if (left + PICKER_W > window.innerWidth - margin) {
      left = window.innerWidth - PICKER_W - margin;
    }
    if (left < margin) left = margin;
    picker.style.top  = top + 'px';
    picker.style.left = left + 'px';
  }

  function attachPicker(textarea) {
    if (!textarea || textarea.dataset.emojiAttached) return;
    textarea.dataset.emojiAttached = 'true';

    const parent = textarea.parentNode;
    const wrap = document.createElement('div');
    wrap.className = 'uc-emoji-wrap';
    parent.insertBefore(wrap, textarea);
    wrap.appendChild(textarea);

    const trigger = document.createElement('button');
    trigger.type = 'button';
    trigger.className = 'uc-emoji-trigger';
    trigger.textContent = '😊';
    trigger.setAttribute('aria-label', 'Open emoji picker');
    wrap.appendChild(trigger);

    const picker = document.createElement('div');
    picker.className = 'uc-emoji-picker';
    document.body.appendChild(picker);

    const grid = document.createElement('div');
    grid.className = 'uc-emoji-grid';
    EMOJIS.forEach(e => {
      const btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'uc-emoji-btn';
      btn.textContent = e;
      btn.addEventListener('mousedown', ev => {
        ev.preventDefault();
        ev.stopPropagation();
        const start = textarea.selectionStart ?? textarea.value.length;
        const end   = textarea.selectionEnd   ?? textarea.value.length;
        textarea.value = textarea.value.slice(0, start) + e + textarea.value.slice(end);
        textarea.focus();
        textarea.setSelectionRange(start + e.length, start + e.length);
        textarea.dispatchEvent(new Event('input', { bubbles: true }));
        picker.classList.remove('open');
      });
      grid.appendChild(btn);
    });
    picker.appendChild(grid);

    trigger.addEventListener('click', ev => {
      ev.stopPropagation();
      const opening = !picker.classList.contains('open');
      document.querySelectorAll('.uc-emoji-picker.open').forEach(p => p.classList.remove('open'));
      if (opening) {
        picker.classList.add('open');
        positionPicker(trigger, picker);
      }
    });

    document.addEventListener('click', ev => {
      if (!wrap.contains(ev.target) && ev.target !== trigger) {
        picker.classList.remove('open');
      }
    });

    window.addEventListener('resize', () => {
      if (picker.classList.contains('open')) positionPicker(trigger, picker);
    });
  }

  function init() {
    injectStyles();
    attachPicker(document.getElementById('create-post-body-input'));
    attachPicker(document.getElementById('post-view-comment-input'));
    attachPicker(document.getElementById('community-desc-input'));        // create community -> description
    attachPicker(document.getElementById('edit-community-desc-input'));   // edit community -> description
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
