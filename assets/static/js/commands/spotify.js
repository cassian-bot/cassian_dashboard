fetch(`/api/v1/spotify/${spotify_id}/index_playlists`)
    .then(response => response.json())
    .then(data => {
        if(data.length <= 0) return;

        holder = document.getElementById("playlists");

        holder.classList.remove('hidden');

        for(let i=0; i < data.length; i++) {
            playlist = data[i];

            const new_element = document.createElement('p');
            new_element.classList.add("rounded-box", "category-element", "command-category", "playlist");
            new_element.textContent = data[i].name;
            new_element.onclick = () => {
                input = document.getElementById("command-input");
                input.value = data[i].link;
                input.dispatchEvent(new Event('keyup'));
            }
            
            holder.appendChild(new_element);
        }
    })