const spotifyButton = document.getElementById('spotify-connection');

let authenticatedError = () => {
    spop({
        template: 'You need to be authenticated to perform this action!',
        position  : 'top-right',
        autoclose: 2000,
        style: 'error'
    }); 
}

if(spotifyButton.classList.contains("not-connected"))
    if (spotifyButton.classList.contains("unauthenticated")) {
        spotifyButton.onclick = authenticatedError;
        spotifyButton.parentElement.onclick = (event) => event.preventDefault();
    } else
        spotifyButton.parentElement.href = '/auth/spotify'
else
    spotifyButton.parentElement.href = '/commands?provider=spotify';

const youtubeButton = document.getElementById('youtube-connection');

if(youtubeButton.classList.contains("not-connected"))
    if (youtubeButton.classList.contains("unauthenticated")) {
        youtubeButton.onclick = authenticatedError;
        youtubeButton.parentElement.onclick = (event) => event.preventDefault();
    } else
        youtubeButton.parentElement.href = '/auth/youtube'
else
    youtubeButton.parentElement.href = '/commands?provider=youtube';

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
        position  : 'top-right',
        autoclose: 2000
    });

};

// In case of a placeholder

let initialValue = document.getElementById("command-input").value

const elements = document.getElementsByClassName('placeholder');

for(let i = 0; i < elements.length; i++) {
    const element = elements.item(i)
    element.textContent = initialValue || element.getAttribute('placeholder');
}

document.getElementById("command-input").onkeyup = (event) => {    
    for(let i = 0; i < elements.length; i++) {
        const element = elements.item(i)

        if(event.target.value !== "")
            element.textContent = event.target.value;
        else
            element.textContent = element.getAttribute('placeholder');
    }
}