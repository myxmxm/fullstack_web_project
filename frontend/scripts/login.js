const url = 'http://localhost:8000';
const loginForm = document.querySelector('#loginForm');

loginForm.addEventListener('submit', async (evt) => {
    evt.preventDefault();
    const formData = new FormData(loginForm);
    const jsonData = {};
    formData.forEach((value, key) => {
        jsonData[key] = value;
    });
    const fetchOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(jsonData),
    };

    try {
        const response = await fetch(url + '/login' , fetchOptions);
        const json = await response.json();
        if (response.ok) {
            sessionStorage.setItem('token', json.token);
            sessionStorage.setItem('user', json.username);
        }
        const messageContainer = document.getElementById('messageContainer');
        const messageText = document.getElementById('messageText');
        messageText.textContent = json.message;
        messageContainer.classList.remove('hidden');
        setTimeout(() => {
            window.location.href = 'index.html';
        }, 2000);
    } catch (error) {
        console.error('Error:', error);
    }
});  