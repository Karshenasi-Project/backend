FROM bitwalker/alpine-elixir-phoenix:latest
WORKDIR /app
RUN mix do local.hex --force, local.rebar --force

COPY ./mix.exs /app/
RUN mix deps.get
RUN mix compile


ENV DATABASE_NAME=nothing
ENV DATABASE_USERNAME=nothing
ENV DATABASE_PASSWORD=nothing
ENV DATABASE_ENDPOINT=http://nothing:80
ENV POOL_SIZE=10
ENV TELEGRAM_BOT_TOKEN=nothing
ENV HEX_HTTP_TIMEOUT=240

COPY ./ /app/
RUN mix deps.get
# RUN mix compile
EXPOSE 4000
ENTRYPOINT ["mix","phx.server"]
