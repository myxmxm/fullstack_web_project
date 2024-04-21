const url = 'http://localhost:8000';
const reservationSection = document.getElementById('reservation_list');

const createReservationCards = (reservations) => {
    reservationSection.innerHTML = '';
    reservations.forEach((reservation) => {

        const div = document.createElement('div');
        div.classList.add('reservation_container');

        const p1 = document.createElement('p');
        p1.innerHTML = `Reservation date: ${reservation.date}`;

        const p2 = document.createElement('p');
        p2.innerHTML = `Reservation time: ${reservation.time}`;

        const p3 = document.createElement('p');
        p3.innerHTML = `Custom name: ${reservation.name}`;

        const p4 = document.createElement('p');
        p4.innerHTML = `Custom email: ${reservation.email}`;

        const p5 = document.createElement('p');
        p5.innerHTML = `Reservation status: ${reservation.status}`;


        reservationSection.appendChild(div);
        div.appendChild(p1);
        div.appendChild(p2);
        div.appendChild(p3);
        div.appendChild(p4);
        div.appendChild(p5);

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
                    const response = await fetch(url + '/reservations/' + reservation.reservation_id, fetchOptions);
                    const json = await response.json();
                    getAllReservations();
                } catch (e) {
                    console.log(e.message);
                }
            });

            if (reservation.status == "unconfirmed") {
                const confirmButton = document.createElement('button');
                confirmButton.innerHTML = 'Confirm';
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
                        const response = await fetch(url + '/reservation/' + reservation.reservation_id, fetchOptions);
                        const json = await response.json();
                        getAllReservations();
                    } catch (e) {
                        console.log(e.message);
                    }
                    
                });

            }

        }

    });
};

const getAllReservations = async () => {
    try {
        const fetchOptions = {
            method: 'GET',
            headers: {
            Authorization: 'Bearer ' + sessionStorage.getItem('token'),
            },
        };
        const response = await fetch(url + '/reservations', fetchOptions);
        const reservations = await response.json();
        console.log(reservations);
        createReservationCards(reservations.reverse());
    } catch (e) {
        console.log(e.message);
    }
};
getAllReservations();