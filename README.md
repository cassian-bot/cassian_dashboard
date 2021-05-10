# CassianDashboard

![Cassian Dashboard Banner](https://raw.githubusercontent.com/cassian-bot/assets/master/cassian_dashboard_banner.png)

Phoenix Dashboard for [Cassian](https://github.com/cassian-bot/cassian).

## Table of contents

- [Requirements](#requirements)
- [Starting up](#starting-up)

### Requirements

The current requirements are:

- Redis
- PostgreSQL
- Elixir (>= 1.11.3)
- Node (>= 14.16.0)
- npm (>= 7.11.2)

### Starting up

You need to follow some steps to setup the server:

- Install dependencies with `mix deps.get`.
- Create and migrate your database with `mix ecto.setup`.
- Install Node.js dependencies with `npm install` inside the `assets` directory.

And you can finally start the Phoenix server:

- Start Phoenix endpoint with `mix phx.server`.

Or you can as well interactively start it with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
