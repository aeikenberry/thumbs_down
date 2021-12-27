FROM elixir:1.6.6
ADD . /app
WORKDIR /app
RUN mix local.hex --force && mix deps.install && mix phx.server
EXPOSE 4000
