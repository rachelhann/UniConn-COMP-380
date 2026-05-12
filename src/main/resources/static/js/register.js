// intercepts register form submission, sends new account details to backend API.
// successs: stores returned JWT in localStorage and redirects to the feed.
// failure: shows error message below
const usernameInput = document.querySelector('input[name="username"]');
usernameInput.addEventListener('input', () => {
  const pos = usernameInput.selectionStart;
  usernameInput.value = usernameInput.value.toLowerCase().replace(/\s/g, '');
  usernameInput.setSelectionRange(pos, pos);
});

document.getElementById('register-form').addEventListener('submit', async (e) => {
  e.preventDefault(); 

  const username = document.querySelector('input[name="username"]').value.trim();
  const email    = document.querySelector('input[name="email"]').value.trim();
  const password = document.querySelector('input[name="password"]').value;
  const errorEl  = document.getElementById('register-error');

  errorEl.textContent = '';

  try {
    const response = await fetch('/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // backend expects csunEmail, not email
      body: JSON.stringify({ username, csunEmail: email, password })
    });

    if (response.ok) {
      const data = await response.json();
      localStorage.setItem('token', data.token); // save JWT for future API calls
      window.location.href = '/feed';
    } else {
      const msg = await response.text();
      errorEl.textContent = msg || 'Registration failed. Please try again.';
    }
  } catch {
    errorEl.textContent = 'Something went wrong. Please try again.';
  }
});
