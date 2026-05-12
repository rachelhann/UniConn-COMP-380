// intercepts login form submission and sends credentials to backend API.
// success: stores returned JWT in localStorage and redirects to feed
// failure: shows error in HTML
document.getElementById('login-form').addEventListener('submit', async (e) => {
  e.preventDefault();

  const email    = document.querySelector('input[name="email"]').value.trim();
  const password = document.querySelector('input[name="password"]').value;
  const errorEl  = document.getElementById('login-error');

  errorEl.textContent = ''; // hides any previous error

  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // backend expects csunEmail, not email
      body: JSON.stringify({ csunEmail: email, password })
    });

    if (response.ok) {
      const data = await response.json();
      localStorage.setItem('token', data.token);
      // fetch username immediately so it's available across all pages
      try {
        const profileRes = await fetch('/api/profile/me', {
          headers: { 'Authorization': 'Bearer ' + data.token }
        });
        if (profileRes.ok) {
          const profile = await profileRes.json();
          if (profile.username) localStorage.setItem('currentUsername', profile.username);
        }
      } catch {}
      window.location.href = '/feed';
    } else {
      errorEl.textContent = 'Invalid email or password.';
    }
  } catch {
    errorEl.textContent = 'Invalid email or password.';
  }
});
