const url = 'http://localhost:8000';
const modForm = document.querySelector('#updateMenuForm');


const getQParam = (param) => {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    return urlParams.get(param);
};
  

const getMenu = async (id) => {
    const fetchOptions = {
        method: 'GET',
        headers: {
        Authorization: 'Bearer ' + sessionStorage.getItem('token'),
        },
    };

    const response = await fetch(url + '/menu/' + id , fetchOptions);
    const menu = await response.json();
    const inputs = modForm.querySelectorAll('input');
    const textareas = modForm.querySelectorAll('textarea');
    textareas[0].value = menu.name;
    textareas[1].value = menu.description;
    inputs[0].value = menu.price;
};

getMenu(getQParam('menu'));

modForm.addEventListener('submit', async (evt) => {
    evt.preventDefault();
    const fd = new FormData(modForm);
    const fetchOptions = {
        method: 'PUT',
        headers: {
        Authorization: 'Bearer ' + sessionStorage.getItem('token'),
        },
        body: fd,
    };

    try {
        const response = await fetch(url + '/menu/' + getQParam('menu') , fetchOptions);
        const json = await response.json();
        const messageContainer = document.getElementById('messageContainer');
        const messageText = document.getElementById('messageText');
        messageText.textContent = json.message;
        messageContainer.classList.remove('hidden');
        setTimeout(() => {
            window.location.href = 'menu.html';
        }, 2000);
    } catch (error) {
        console.error('Error:', error);
    }
});  

const cancelButton = document.getElementById('cancelButton');

cancelButton.addEventListener('click', () => {
    window.location.href = 'menu.html';
});