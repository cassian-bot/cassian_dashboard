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