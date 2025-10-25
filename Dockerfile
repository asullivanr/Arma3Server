FROM debian:bookworm-slim

LABEL maintainer="Brett - github.com/brettmayson"
LABEL org.opencontainers.image.source=https://github.com/brettmayson/arma3server

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        python3 python3-venv python3-pip \
        lib32stdc++6 lib32gcc-s1 \
        libcurl4 \
        wget ca-certificates curl \
        libstdc++6 libssl3 libc6 \
        git \
    ; \
    rm -rf /var/lib/apt/lists/*

ENV VENV=/opt/venv
RUN set -eux; \
    python3 -m venv "$VENV"; \
    "$VENV/bin/pip" install --no-cache-dir -U pip; \
    "$VENV/bin/pip" install --no-cache-dir \
        zstandard \
        "git+https://github.com/brettmayson/valvepythonsteam#egg=steam[client]"

ENV PATH="$VENV/bin:$PATH" \
    PYTHONUNBUFFERED=1

ENV ARMA_BINARY=./arma3server_x64 \
    ARMA_CONFIG=main.cfg \
    ARMA_BASIC_CONFIG=basic.cfg \
    ARMA_PARAMS= \
    ARMA_PROFILE=main \
    ARMA_WORLD=empty \
    ARMA_LIMITFPS=1000 \
    ARMA_CDLC= \
    HEADLESS_CLIENTS=0 \
    HEADLESS_CLIENTS_PROFILE="\$profile-hc-\$i" \
    PORT=2302 \
    MODS_LOCAL=true \
    CLEAR_KEYS=true \
    MODS_PRESET= \
    MODS_SERVER_PRESET= \
    MODS_WHITELIST_PRESET= \
    SKIP_INSTALL=false

EXPOSE 2302/udp 2303/udp 2304/udp 2305/udp 2306/udp

WORKDIR /arma3
VOLUME /arma3/server

STOPSIGNAL SIGINT

COPY *.py /

CMD ["python", "/launch.py"]
