fetch(`/api/v1/spotify/${spotify_id}/index_playlists`)
    .then(response => response.json())
    .then(data => {
        for(let i=0; i < data.length; i++) {
            playlist = data[i];
            console.log(playlist);
        }
    })