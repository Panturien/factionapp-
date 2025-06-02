// const images = ['assets/wallpaper.png', 'assets/wallpaper2.png', 'assets/wallpaper3.png', 'assets/wallpaper4.png', 'assets/wallpaper5.png', 'assets/wallpaper.png'];
// let index = 0;

// setInterval(() => {
//   index = (index + 1) % images.length;
//   const img = document.getElementById('wallpaper');
//   img.style.opacity = 0.;
//   setTimeout(() => {
//     img.src = images[index];
//     img.style.opacity = 1;
//   }, 1000);
// }, 10000);

$(window).scroll(function() {
    $(this).scrollTop(0);
});

$("#funk_app, #dispatches, #activedispatches, #note, #frakbank").hide();

function fadeOutElements() {
    $("#funk_app, #main, #note, #frakbank, #dispatches, #activedispatches").fadeOut(200);
}

function openDispatches() {
    fadeOutElements();
    $("#dispatches").fadeIn(200);
}

function openActiveDispatches() {
    fadeOutElements();
    $("#activedispatches").fadeIn(200);
}

function getBack() {
    fadeOutElements();
    $("#main").fadeIn(200);
}

function openFunk() {
    fadeOutElements();
    $("#funk_app").fadeIn(200);
}

function openNotes() {
    fadeOutElements();
    $("#note").fadeIn(500);
}

function openFrakBanking() {
    fadeOutElements();
    $("#frakbank").fadeIn(200);
}

$("#notebtn").click(function() {
    $("#activenotes").text($("#createnotes").val());
});
