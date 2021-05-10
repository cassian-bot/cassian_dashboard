let authenticatedError = () => {
    spop({
        template: 'You need to be authenticated to perform this action!',
        position: 'top-right',
        autoclose: 2000,
        style: 'error'
    });
}

let unimplemented = () => {
    spop({
        template: 'Connection not yet implemented!',
        position: 'top-right',
        autoclose: 2000,
        style: 'error'
    });
}

function setupButton(buttonName, actualProvider = undefined) {
    const button = document.getElementById(`${buttonName}-connection`);

    if (button.classList.contains("not-connected"))
        if (button.classList.contains("unauthenticated")) {
            button.onclick = authenticatedError;
            button.parentElement.onclick = (event) => event.preventDefault();
        } else if (buttonName != "spotify") {
            button.onclick = unimplemented;
            button.parentElement.onclick = (event) => event.preventDefault();
        }
        else
            button.parentElement.href = `/auth/${buttonName}`;
    else
        button.parentElement.href = `/commands?provider=${actualProvider || buttonName}`;
}

setupButton('youtube', 'google');
setupButton('spotify');
setupButton('soundcloud');

document.addEventListener('click', event => {
    if (event.target.matches(".copy-button")) {
        copyToClipboard(getStringFromP(event.target))
    } else if (event.target.matches(".copy-logo")) {
        copyToClipboard(getStringFromP(event.target.parentElement));
    } else if (event.target.matches(".copy-path")) {
        copyToClipboard(getStringFromP(event.target.parentElement.parentElement));
    }
})

function getStringFromP(p) {
    const element = p.parentElement;
    return element.innerText.trim();
}

const copyToClipboard = str => {
    const el = document.createElement('textarea');
    el.value = str;
    el.setAttribute('readonly', '');
    el.style.position = 'absolute';
    el.style.left = '-9999px';
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);



    spop({
        template: 'Coppied to clipboard!',
        position: 'top-right',
        autoclose: 2000
    });

};

// In case of a placeholder

let initialValue = document.getElementById("command-input").value

const elements = document.getElementsByClassName('placeholder');

for (let i = 0; i < elements.length; i++) {
    const element = elements.item(i)
    element.textContent = initialValue || element.getAttribute('placeholder');
}

document.getElementById("command-input").onkeyup = (event) => {
    for (let i = 0; i < elements.length; i++) {
        const element = elements.item(i)

        if (event.target.value !== "")
            element.textContent = event.target.value;
        else
            element.textContent = element.getAttribute('placeholder');
    }
}