// Lillian Foster
// forgotPassword.js - two-step forgot password flow using security questions
// Step 1: user enters email -> backend returns their security question
// Step 2: user answers question + enters new password -> backend resets password

let userEmail = ''; // store email between steps

// helper to parse error messages from backend JSON responses
function parseError(text, fallback) {
  try {
    const json = JSON.parse(text);
    return json.error || json.message || fallback;
  } catch {
    return text || fallback;
  }
}

// ── Step 1: get security question by email ──────────────────────────────────
document.getElementById('step1-form').addEventListener('submit', async (e) => {
  e.preventDefault();

  const email = document.getElementById('forgot-email').value.trim();
  const msg   = document.getElementById('step1-message');

  msg.className = 'forgot-message';
  msg.style.display = 'none';

  try {
    const res = await fetch(`/api/auth/forgot-password/question?csunEmail=${encodeURIComponent(email)}`);

    if (res.ok) {
      const question = await res.text();

      userEmail = email;

      document.getElementById('security-question').textContent = question;
      document.getElementById('step1-form').style.display = 'none';
      document.getElementById('step2-form').style.display = 'block';

    } else {
      const errorText = await res.text();
      msg.textContent = parseError(errorText, 'No account found with that email address.');
      msg.classList.add('error');
      msg.style.display = 'block';
    }

  } catch {
    msg.textContent = 'Something went wrong. Please try again.';
    msg.classList.add('error');
    msg.style.display = 'block';
  }
});

// ── Step 2: answer security question and reset password ────────────────────
document.getElementById('step2-form').addEventListener('submit', async (e) => {
  e.preventDefault();

  const answer          = document.getElementById('security-answer').value.trim();
  const newPassword     = document.getElementById('new-password').value;
  const confirmPassword = document.getElementById('confirm-password').value;
  const msg             = document.getElementById('step2-message');

  msg.className = 'forgot-message';
  msg.style.display = 'none';

  if (newPassword !== confirmPassword) {
    msg.textContent = 'Passwords do not match.';
    msg.classList.add('error');
    msg.style.display = 'block';
    return;
  }

  if (newPassword.length < 8) {
    msg.textContent = 'Password must be at least 8 characters.';
    msg.classList.add('error');
    msg.style.display = 'block';
    return;
  }

  try {
    const res = await fetch('/api/auth/forgot-password/reset', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        csunEmail:   userEmail,
        answer:      answer,
        newPassword: newPassword
      })
    });

    if (res.ok) {
      msg.textContent = 'Password reset successfully! Redirecting to login...';
      msg.classList.add('success');
      msg.style.display = 'block';
      setTimeout(() => { window.location.href = '/login'; }, 2000);

    } else {
      const errorText = await res.text();
      msg.textContent = parseError(errorText, 'Incorrect answer. Please try again.');
      msg.classList.add('error');
      msg.style.display = 'block';
    }

  } catch {
    msg.textContent = 'Something went wrong. Please try again.';
    msg.classList.add('error');
    msg.style.display = 'block';
  }
});