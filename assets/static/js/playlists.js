const playlists = document.getElementsByClassName("playlist");
const input = document.getElementById("command-input");

for(let i=0; i < playlists.length; i++) {
    const element = playlists[i];
    element.onclick = () => {
        input.value = element.getAttribute('src');
        input.dispatchEvent(new Event('keyup'));
    }
}