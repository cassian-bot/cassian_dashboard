const spotifyButton = document.getElementById('spotify-connection');

if(spotifyButton.classList.contains("not-connected"))
    spotifyButton.parentElement.href = '/auth/spotify'
else {
    spotifyButton.parentElement.href = 'javascript:void(0)'
    spotifyButton.onclick = () => {
        window.location.href = '/commands/spotify'
    }
}
