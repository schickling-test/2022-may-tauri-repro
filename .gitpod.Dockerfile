FROM rust:1.61-slim-bullseye as builder
WORKDIR /opt/overtone
COPY . .
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt update && \
    apt install -yq build-essential \
        libwebkit2gtk-4.0-dev  \
        nodejs \
        npm \
        build-essential \
        curl \
        wget \
        libssl-dev \
        libgtk-3-dev \
        libayatana-appindicator3-dev \
        librsvg2-dev && \
    npm install
RUN npm run tauri build -- --debug

FROM gitpod/workspace-full-vnc
USER root
WORKDIR /opt/overtone
RUN apt update && \
    apt upgrade -yq && \
    apt install -yq libgtk-3-dev && \
    apt autoremove -yq && \
    apt clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*
COPY --from=builder /opt/overtone/src-tauri/target/debug/ /opt/overtone
USER gitpod
ENTRYPOINT ["overtone"]
