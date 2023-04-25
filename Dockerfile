## Build 
FROM golang:1.20-bullseye as builder

ENV GO111MODULE on
ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOARCH amd64
ENV GOPROXY https://goproxy.cn

ENV CADDY_PATH /caddy
ENV CADDY_VERSION v2.6.4

WORKDIR $CADDY_PATH

RUN set -eux; \
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest; \
    xcaddy build $CADDY_VERSION --with github.com/caddy-dns/alidns

## Package
FROM ghcr.io/batx-dev/debian:bullseye-slim

COPY --from=builder /caddy/caddy /usr/bin/caddy

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	curl -L -o /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/305fe484cc8a9ac72900e8cc172d652102a87240/config/Caddyfile"; \
	curl -L -o /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/305fe484cc8a9ac72900e8cc172d652102a87240/welcome/index.html"; \
    setcap cap_net_bind_service=+ep /usr/bin/caddy; \
    chmod +x /usr/bin/caddy

ENV CADDY_VERSION v2.6.4
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]