const url = 'http://10.120.32.84:8000';
const addPromotionForm = document.querySelector('#addPromotionForm');

addPromotionForm.addEventListener('submit', async (evt) => {
    evt.preventDefault();
    const formData = new FormData(addPromotionForm);
    const jsonData = {};
    formData.forEach((value, key) => {
        jsonData[key] = value;
    });
    const fetchOptions = {
        method: 'POST',
        headers: {
            Authorization: 'Bearer ' + sessionStorage.getItem('token'),
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(jsonData),
    };

    try {
        const response = await fetch(url + '/promotion', fetchOptions);
        const json = await response.json();
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

const cancelButton = document.getElementById('cancelButton');

cancelButton.addEventListener('click', () => {
    window.location.href = 'index.html';
});