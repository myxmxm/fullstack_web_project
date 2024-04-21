const nav = document.getElementById("nav");
const isLoggedIn = sessionStorage.getItem('user');
const logoutItem = document.createElement("li");
const reservationItem = document.createElement("li");

if (isLoggedIn) {
    
    reservationItem.innerHTML = '<a href="reservations.html" id="reservations">Reservations</a>';
    logoutItem.innerHTML = '<a href="#" id="logout">Logout</a>';
    nav.appendChild(reservationItem);
    nav.appendChild(logoutItem);

    const logoutLink = document.getElementById("logout");
    logoutLink.addEventListener("click", function(event) {
        event.preventDefault();
        sessionStorage.removeItem('user');
        sessionStorage.removeItem('token');
        location.reload(); 
    });

    
} else {
    logoutItem.innerHTML = '<a href="login.html" id="login">Login</a>';
    nav.appendChild(logoutItem);
}
