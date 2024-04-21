const url = 'http://10.120.32.84:8000';
const reservationForm = document.getElementById("reservationForm");

reservationForm.addEventListener('submit', async (evt) => {
    evt.preventDefault();
    const formData = new FormData(reservationForm);
    const jsonData = {};
    formData.forEach((value, key) => {
        jsonData[key] = value;
    });

    try {
        const response = await fetch(url + '/reservation', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(jsonData),
        });
        const json = await response.json();
        const messageContainer = document.getElementById('messageContainer');
        const messageText = document.getElementById('messageText');
        messageText.textContent = json.message;
        messageContainer.classList.remove('hidden');
        setTimeout(() => {
            messageContainer.classList.add('hidden');
        }, 2000);
        document.getElementById("reservationForm").reset()
    } catch (error) {
        console.error('Error:', error);
        alert('Error: ' + error.message);
    }
});

const loggedIn = sessionStorage.getItem('user');

if (loggedIn) {
    document.getElementById('addPromotionContainer').classList.remove('hidden');   
} 
