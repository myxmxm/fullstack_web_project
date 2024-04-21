const url = 'http://10.120.32.84:8000';
const updatePromotionForm = document.querySelector('#updatePromotionForm');

const getQParam = (param) => {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    return urlParams.get(param);
};
  

const getPromotion = async (id) => {
    const fetchOptions = {
        method: 'GET',
        headers: {
        Authorization: 'Bearer ' + sessionStorage.getItem('token'),
        },
    };

    const response = await fetch(url + '/promotion/' + id , fetchOptions);
    const promotion = await response.json();
    const textareas = updatePromotionForm.querySelectorAll('textarea');
    textareas[0].value = promotion.name;
    textareas[1].value = promotion.description;
};

getPromotion(getQParam('promotion'));

updatePromotionForm.addEventListener('submit', async (evt) => {
    evt.preventDefault();
    const formData = new FormData(updatePromotionForm);
    const jsonData = {};
    formData.forEach((value, key) => {
        jsonData[key] = value;
    });
    const fetchOptions = {
        method: 'PUT',
        headers: {
            Authorization: 'Bearer ' + sessionStorage.getItem('token'),
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(jsonData),
    };

    try {
        const response = await fetch(url + '/promotion/'+ getQParam('promotion'), fetchOptions);
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