FROM hexpm/elixir:1.17.3-erlang-27.2.1-debian-bookworm-20241202-slim

WORKDIR /app

RUN apt-get update && apt-get install --yes --no-install-recommends build-essential git && rm -rf /var/lib/apt/lists/*

COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force && mix deps.get

COPY . .
RUN mix deps.compile && mix compile

EXPOSE 4000
