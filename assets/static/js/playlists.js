const playlists = document.getElementsByClassName("playlist");
const input = document.getElementById("command-input");

for(let i=0; i < playlists.length; i++) {
    const element = playlists[i];
    element.onclick = (event) => {
        const curr_playlist = document.getElementsByClassName('selected-playlist')[0];

        if(curr_playlist != undefined)
            curr_playlist.classList.remove("selected-playlist");

        event.target.classList.add("selected-playlist");
        input.value = element.getAttribute('src');
        input.dispatchEvent(new Event('keyup'));
    }
}