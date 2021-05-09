fetch(`/api/v1/spotify/${spotify_id}/index_playlists`)
    .then(response => response.json())
    .then(data => {
        if(data.length <= 0) return;

        holder = document.getElementById("playlists");

        holder.classList.remove('hidden');

        for(let i=0; i < data.length; i++) {
            playlist = data[i];

            const new_element = document.createElement('p');
            new_element.classList.add("rounded-box", "category-element", "command-category");
            new_element.textContent = data[i].name;
            new_element.onclick = () => {
                window.location.href = `/commands?provider=spotify&placeholder=${data[i].link}`
            }
            
            holder.appendChild(new_element);
        }
    })