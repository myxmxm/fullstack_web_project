const url = 'http://10.120.32.84:8000';
const messageSection = document.getElementById('message_list');

const createMessageCards = (messages) => {
    messageSection.innerHTML = '';
    messages.forEach((message) => {

        const div = document.createElement('div');
        div.classList.add('message_container');

        const p1 = document.createElement('p');
        p1.innerHTML = `Custom email: ${message.email}`;

        const p2 = document.createElement('p');
        p2.innerHTML = `Message: ${message.message}`;

        const p3 = document.createElement('p');
        p3.innerHTML = `Message status: ${message.status}`;


        messageSection.appendChild(div);
        div.appendChild(p1);
        div.appendChild(p2);
        div.appendChild(p3);

        if (isLoggedIn) {
            
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
                    const response = await fetch(url + '/message/' + message.message_id, fetchOptions);
                    const json = await response.json();
                    getAllmessages();
                } catch (e) {
                    console.log(e.message);
                }
            });

            if (message.status == "unacknowledged") {
                const confirmButton = document.createElement('button');
                confirmButton.innerHTML = 'Acknowledge';
                confirmButton.classList.add('button');
                div.appendChild(confirmButton)
                confirmButton.addEventListener('click', async () => {     
                    const fetchOptions = {
                        method: 'PUT',
                        headers: {
                        Authorization: 'Bearer ' + sessionStorage.getItem('token'),
                        },
                    };
                    try {
                        const response = await fetch(url + '/message/' + message.message_id, fetchOptions);
                        const json = await response.json();
                        getAllmessages();
                    } catch (e) {
                        console.log(e.message);
                    }
                    
                });

            }

        }

    });
};

const getAllmessages = async () => {
    try {
        const fetchOptions = {
            method: 'GET',
            headers: {
            Authorization: 'Bearer ' + sessionStorage.getItem('token'),
            },
        };
        const response = await fetch(url + '/messages', fetchOptions);
        const messages = await response.json();
        console.log(messages);
        createMessageCards(messages.reverse());
    } catch (e) {
        console.log(e.message);
    }
};
getAllmessages();