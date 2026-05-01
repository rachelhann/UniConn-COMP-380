// intercepts register form submission, sends new account details to backend API.
// success: stores returned JWT in localStorage and redirects to the feed.
// failure: shows error message below
document.getElementById('register-form').addEventListener('submit', async (e) => {
  e.preventDefault();

  const username       = document.querySelector('input[name="username"]').value.trim();
  const email          = document.querySelector('input[name="email"]').value.trim();
  const password       = document.querySelector('input[name="password"]').value;
  const secretQuestion = document.querySelector('select[name="secretQuestion"]').value.trim();
  const secretAnswer   = document.querySelector('input[name="secretAnswer"]').value.trim();
  const errorEl        = document.getElementById('register-error');

  errorEl.textContent = '';

  try {
    const response = await fetch('/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // backend expects csunEmail, not email
      body: JSON.stringify({ username, csunEmail: email, password, secretQuestion, secretAnswer })
    });

    if (response.ok) {
      const data = await response.json();
      localStorage.setItem('token', data.token); // save JWT for future API calls
      window.location.href = '/feed';
    } else {
      const msg = await response.text();
      try {
        const json = JSON.parse(msg);
        errorEl.textContent = json.error || json.message || 'Registration failed. Please try again.';
      } catch {
        errorEl.textContent = msg || 'Registration failed. Please try again.';
      }
    }
  } catch {
    errorEl.textContent = 'Something went wrong. Please try again.';
  }
});