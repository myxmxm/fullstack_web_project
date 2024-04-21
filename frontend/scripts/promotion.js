// const url = 'http://localhost:8000';
const promotionSection = document.getElementById('promotions');
const addPromotionButtion = document.getElementById('addPromotionButton');

addPromotionButtion.addEventListener('click', async () => {
    window.location.href = "add_promotion.html"
});

const createPromotionCards = (promotions) => {
    // clear ul
    promotionSection.innerHTML = '';
    promotions.forEach((promotion) => {

        const div = document.createElement('div');
        div.classList.add('promotion_container');

        const h = document.createElement('h3');
        h.innerHTML = promotion.name;

        const p = document.createElement('p');
        p.innerHTML = `Promotion detail: ${promotion.description}`;


        promotionSection.appendChild(div);
        div.appendChild(h);
        div.appendChild(p);

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
                    const response = await fetch(url + '/promotion/' + promotion.promotion_id, fetchOptions);
                    const json = await response.json();
                    console.log('delete response', json);
                    getAllPromotion();
                } catch (e) {
                    console.log(e.message);
                }
            });

            const modifyButton = document.createElement('button');
            modifyButton.innerHTML = 'Modify';
            modifyButton.classList.add('button');
            div.appendChild(modifyButton)
            modifyButton.addEventListener('click', async () => {
                window.location.href = "modify_promotion.html?promotion="+ encodeURIComponent(promotion.promotion_id);;
            });
        }
    });
};


const getAllPromotion = async () => {
    try {
        const response = await fetch(url + '/promotions');
        const promotions = await response.json();
        console.log(promotions)
        createPromotionCards(promotions.reverse());
    } catch (e) {
        console.log(e.message);
    }
};
getAllPromotion();