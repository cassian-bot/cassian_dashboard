// Specific error messages.

let authenticatedError = () => {
    spop({
        template: 'You need to be authenticated to perform this action!',
        position: 'top-right',
        autoclose: 2000,
        style: 'error'
    });
}

// Setup the connection buttons

function setupButton(buttonName) {
    const button = document.getElementById(`${buttonName}-connection`);

    if (button.classList.contains("not-connected"))
        if (button.classList.contains("unauthenticated")) {
            button.onclick = authenticatedError;
            button.parentElement.onclick = (event) => event.preventDefault();
        }
        else
            button.parentElement.href = `/auth/${buttonName}`;
    else
        button.parentElement.href = `/commands?provider=${buttonName}`;
}

setupButton('youtube');
setupButton('spotify');
setupButton('soundcloud');

// Generally commands

const commands = document.getElementsByClassName("command-box");

// Setup copy-clicking

const copiedMessage = () => {
    spop({
        template: 'Coppied to clipboard!',
        position: 'top-right',
        autoclose: 2000
    });
}

document.addEventListener('click', event => {
    if (event.target.matches(".copy-button"))
        copyToClipboard(getStringFromP(event.target))
    else if (event.target.matches(".copy-logo"))
        copyToClipboard(getStringFromP(event.target.parentElement));
    else if (event.target.matches(".copy-path"))
        copyToClipboard(getStringFromP(event.target.parentElement.parentElement));
})

function getStringFromP(p) {
    return p.parentElement.innerText.trim();
}

const copyToClipboard = str => {
    const temp = document.createElement('textarea');
    temp.value = str;
    temp.setAttribute('readonly', '');
    temp.style.position = 'absolute';
    temp.style.left = '-9999px';
    document.body.appendChild(temp);
    temp.select();
    document.execCommand('copy');
    document.body.removeChild(temp);
    copiedMessage();
};

// Setup category clicking

document.addEventListener('click', event => {
    if (event.target.matches(".command-category") && !event.target.matches(".selected-category")) {
        const newCategory = event.target.textContent.toLowerCase().split(" ")[0];
    
        let oldSelected;
        if ((oldSelected = document.getElementsByClassName("selected-category")[0])) {
            if (oldSelected == event.target) return;
    
            oldSelected.classList.remove("selected-category");
            event.target.classList.add("selected-category");
        } else
            event.target.classList.add("selected-category");
    
        if (newCategory == "all")
            for (let i = 0; i < commands.length; i++)
                commands[i].style.display = 'flex';
        else
            for (let i = 0; i < commands.length; i++) {
                let command = commands[i];
    
                command.style.display =
                    command.classList.contains(`${newCategory}-category`) ? 'flex' : 'none';
            }
    }
})

// In case of a placeholder

let initialValue = document.getElementById("command-input").value

const placeholders = document.getElementsByClassName('placeholder');

for (let i = 0; i < placeholders.length; i++) {
    const placeholder = placeholders.item(i)
    placeholder.textContent = initialValue || placeholder.getAttribute('placeholder');
}

document.getElementById("command-input").onkeyup = (event) => {
    for (let i = 0, placeholder; i < placeholders.length; i++)
        placeholders.item(i)
            .textContent = event.target.value || placeholders.item(i).getAttribute('placeholder');
}