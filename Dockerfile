FROM erlang:22

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.9.0" \
    LANG=C.UTF-8 	        \
	MIX_ENV=prod

# install elixir 
RUN set -xe                                                                                         \
    && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
    && ELIXIR_DOWNLOAD_SHA256="dbf4cb66634e22d60fe4aa162946c992257f700c7db123212e7e29d1c0b0c487"    \
    && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL                                          \
    && echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c -                           \
    && mkdir -p /usr/local/src/elixir                                                               \
    && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz                     \
    && rm elixir-src.tar.gz                                                                         \
    && cd /usr/local/src/elixir                                                                     \
    && make install clean 

# download project and install deps
RUN cd ~/                                                               \
    && git clone https://github.com/Fl4m3Ph03n1x/footbal_interface.git  \
    && cd footbal_interface/                                            \
    && mix local.hex --force                                            \
    && mix local.rebar --force                                          \
    && mix deps.get                                                     \
	&& mix release 

EXPOSE 8080

CMD ~/footbal_interface/_build/prod/rel/footbal_interface/bin/footbal_interface start