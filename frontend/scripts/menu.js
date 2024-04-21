
const menuSection = document.getElementById('menu');
const loggedIn = sessionStorage.getItem('user');


const url = 'http://localhost:8000';

const createMenuCards = (menus) => {
    menuSection.innerHTML = '';
    menus.forEach((menu) => {

        const div = document.createElement('div');
        div.classList.add('menu_container');

        const img = document.createElement('img');
        img.src = url + '/static/' + menu.menu_pic;
        img.onerror = () => {
            img.src = 'https://picsum.photos/600/400'
        }
        img.classList.add('menu_image');

        const h = document.createElement('h2');
        h.innerHTML = `${menu.name}`;
        h.classList.add('menu_name');

        const p1 = document.createElement('p');
        p1.innerHTML = `Description: ${menu.description}`;
        p1.classList.add('menu_description');

        const p2 = document.createElement('p');
        p2.innerHTML = `Price: ${menu.price} euro`;
        p2.classList.add('menu_price');


        menuSection.appendChild(div);
        div.appendChild(h);
        div.appendChild(img);
        div.appendChild(p1);
        div.appendChild(p2);

        if (loggedIn) {
            
            const deleteButton = document.createElement('button');
            deleteButton.innerHTML = 'Delete';
            deleteButton.classList.add('button');
            div.appendChild(deleteButton)
            deleteButton.addEventListener('click', async () => {
                const fetchOptions = {
                    method: 'DELETE',
                    headers: {
                    Authorization: 'Bearer ' + sessionStorage.getItem('token'),
                    },
                };
                try {
                    const response = await fetch(url + '/menu/' + menu.menu_id, fetchOptions);
                    const json = await response.json();
                    console.log('delete response', json);
                    getAllMenus();
                } catch (e) {
                    console.log(e.message);
                }
            });

            const modifyButton = document.createElement('button');
            modifyButton.innerHTML = 'Modify';
            modifyButton.classList.add('button');
            div.appendChild(modifyButton)
            modifyButton.addEventListener('click', async () => {
                window.location.href = "modify_menu.html?menu="+ encodeURIComponent(menu.menu_id);;
            });
        }

    });
};

const getAllMenus = async () => {
    try {
        const response = await fetch(url + '/menus');
        const menus = await response.json();
        console.log(menus)
        createMenuCards(menus.reverse());
    } catch (e) {
        console.log(e.message);
    }
};
getAllMenus();

if (loggedIn) {

    const addForm = document.getElementById('menuForm');

    addForm.addEventListener('submit', async (evt) => {
        evt.preventDefault();
        const fd = new FormData(addForm);
        const fetchOptions = {
            method: 'POST',
            headers: {
            Authorization: 'Bearer ' + sessionStorage.getItem('token'),
            },
            body: fd,
        };

        try {
            const response = await fetch(url + '/menu', fetchOptions);
            const json = await response.json();
            showCustomAlert(json.message);
        } catch (error) {
            console.error('Error:', error);
        }
    });  
} else {
    document.getElementById('add_menu').style.display = 'none';

}




function displayImage(input) {
    const preview = document.getElementById('imagePreview');
    while (preview.firstChild) {
        preview.removeChild(preview.firstChild);
    }

    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            const image = document.createElement('img');
            image.src = e.target.result;
            image.style.maxWidth = '200px';
            preview.appendChild(image);
        }
        reader.readAsDataURL(input.files[0]);
    }
}



