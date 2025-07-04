// You can ignore this file. All it does is make the UI work on your browser.

window.addEventListener("load", () => {
    if (window.invokeNative) {
        const phoneWrapper = document.getElementById("phone-wrapper");
        const app = phoneWrapper.querySelector(".app");

        phoneWrapper.parentNode.insertBefore(app, phoneWrapper);
        phoneWrapper.parentNode.removeChild(phoneWrapper);
        return;
    }

    document.getElementById("phone-wrapper").style.display = "none";
    document.body.style.visibility = "visible";

    function center() {
        document.getElementById("phone-wrapper").style.transform = "scale(100%)";
    }

    center();
    window.addEventListener("resize", center);
});