const nav = document.getElementById("nav");
const isLoggedIn = sessionStorage.getItem('user');
const logoutItem = document.createElement("li");
const reservationItem = document.createElement("li");
const messageItem = document.createElement("li");

if (isLoggedIn) {
    var navLinks = document.querySelectorAll('nav ul li a');
    reservationItem.innerHTML = '<a href="reservations.html" id="reservations">Reservations</a>';
    messageItem.innerHTML = '<a href="message.html" id="messages">Messages</a>';
    logoutItem.innerHTML = '<a href="#" id="logout">Logout</a>';
    nav.appendChild(reservationItem);
    nav.appendChild(messageItem);
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

var currentPageUrl = window.location.href;
var navLinks = document.querySelectorAll('nav ul li a');

navLinks.forEach(function(link) {
    if (link.href === currentPageUrl) {
        link.classList.add('selected');
    }
});

