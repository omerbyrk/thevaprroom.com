/***
 * Don't delete below code!!! It is working for [auto form field](username and password). 
 */

function addDeleteMyAccount(parentSelector) {
    if (!parentSelector || parentSelector === ``) return;
    function addDeleteMyAccountButton() {
        var parentElement = document.querySelector(parentSelector);
        var deleteMyButton = document.createElement("button");
        deleteMyButton.innerText = "Delete My Account";
        deleteMyButton.id = "deleteMyAccount";
        deleteMyButton.style.marginTop = "10px";
        deleteMyButton.style.marginBottom = "10px";
        deleteMyButton.style.width = "100%";
        deleteMyButton.style.background = "red";
        deleteMyButton.style.fontSize = "18px";
        deleteMyButton.style.color = "white";
        deleteMyButton.onclick = (e) => {
            e.preventDefault();
            confirm("Do you want to delete the account with all the stored data? It will be deleted if you confirm this dialog. ")
        };
        if (!document.getElementById('deleteMyAccount')) {
            parentElement.appendChild(deleteMyButton);
        }
    }
    setInterval(addDeleteMyAccountButton, 1000);
    addDeleteMyAccountButton();
}

try {
    function changeInputValue(input, value) {

        var nativeInputValueSetter = Object.getOwnPropertyDescriptor(
            window.HTMLInputElement.prototype,
            "value"
        ).set;
        nativeInputValueSetter.call(input, value);

        var inputEvent = new Event("input", { bubbles: true });
        input.dispatchEvent(inputEvent);
    }

    document.querySelector(doom_username).addEventListener("keyup", (e) => {
        window.flutter_inappwebview.callHandler("Username", e.target.value);
    });
    document.querySelector(doom_password).addEventListener("keyup", (e) => {
        window.flutter_inappwebview.callHandler("Password", e.target.value);
    });

    if (username) {
        changeInputValue(document.querySelector(doom_username), username);
    }

    if (password) {
        changeInputValue(document.querySelector(doom_password), password);
    }
} catch (e) {
}



