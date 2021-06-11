placeholder = document.getElementById('user_image_own')

fetch(`/api/v1/discord/${placeholder.getAttribute('uid')}`)
    .then(response => response.json())
    .then(data =>
        document.getElementById('user_image_own')
            .src = `https://cdn.discordapp.com/avatars/${data.body.id}/${data.body.avatar}?size=64`
    )