// auth-guard.js
(function () {
    if (!localStorage.getItem('token')) {
        window.location.replace('/auth-guard.html');
    }
})();
