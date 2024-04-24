const url = 'http://10.120.32.84:8000';
const messageForm = document.getElementById("messageForm");

messageForm.addEventListener('submit', async (evt) => {
    evt.preventDefault();
    const formData = new FormData(messageForm);
    const jsonData = {};
    formData.forEach((value, key) => {
        jsonData[key] = value;
    });

    try {
        const response = await fetch(url + '/message', {
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
        document.getElementById("messageForm").reset()
    } catch (error) {
        console.error('Error:', error);
        alert('Error: ' + error.message);
    }
});