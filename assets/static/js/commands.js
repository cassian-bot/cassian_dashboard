const spotifyButton = document.getElementById('spotify-connection');

if(spotifyButton.classList.contains("not-connected"))
    spotifyButton.parentElement.href = '/auth/spotify'
else {
    spotifyButton.parentElement.href = 'javascript:void(0)'
    spotifyButton.onclick = () => {
        window.location.href = '/commands?provider=spotify'
    }
}

const youtubeButton = document.getElementById('youtube-connection');

if(youtubeButton.classList.contains("not-connected"))
youtubeButton.parentElement.href = '/auth/youtube'
else {
    youtubeButton.parentElement.href = 'javascript:void(0)'
    youtubeButton.onclick = () => {
        window.location.href = '/commands?provider=youtube'
    }
}

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

document.getElementById("command-input").onkeyup = (event) => {
    console.log(event.target)
    console.log(`Key is: ${event.key}`);

    const elements = document.getElementsByClassName('placeholder');
    
    for(let i = 0; i < elements.length; i++) {
        const element = elements.item(i)

        if(event.target.value !== "")
            element.textContent = event.target.value;
        else
            element.textContent = element.getAttribute('placeholder');
    }
}