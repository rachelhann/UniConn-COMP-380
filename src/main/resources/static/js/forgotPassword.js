// Intercepts the forgot password form and sends the email to the backend API.
// Shows a success message if the email is found, or an error message if not.
// NOTE: requires backend endpoint POST /api/auth/forgot-password to be implemented.
document.getElementById('forgot-form').addEventListener('submit', async (e) => {
  e.preventDefault(); // stop the form from doing a normal page reload

  const email = document.getElementById('forgot-email').value.trim();
  const msg   = document.getElementById('forgot-message');

  // reset message state before each attempt
  msg.className = 'forgot-message';
  msg.textContent = '';

  try {
    const res = await fetch('/api/auth/forgot-password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // backend expects csunEmail, matching the same field used in login/register
      body: JSON.stringify({ csunEmail: email })
    });

    if (res.ok) {
      msg.textContent = 'Password recovery email successfully sent to ' + email + '.';
      msg.classList.add('success');
    } else {
      // email not found in the system
      msg.textContent = 'No account found with that email address.';
      msg.classList.add('error');
    }
  } catch {
    msg.textContent = 'Something went wrong. Please try again.';
    msg.classList.add('error');
  }

});
