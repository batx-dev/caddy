.PHONY: all
all:
	@echo "make image or push"

.PHONY: image
image:
	CADDY_VERSION=v2.6.4 \
	docker build \
		-t ghcr.io/batx-dev/caddy:2.6.4-bullseye \
		-t ghcr.io/batx-dev/caddy:2.6-bullseye \
		-t ghcr.io/batx-dev/caddy:2-bullseye \
		-t ghcr.io/batx-dev/caddy:latest \
		.

.PHONY: push
push:
	docker push \
		ghcr.io/batx-dev/caddy:2.6.4-bullseye 
	docker push \
		ghcr.io/batx-dev/caddy:2.6-bullseye 
	docker push \
		ghcr.io/batx-dev/caddy:2-bullseye 
	docker push \
		ghcr.io/batx-dev/caddy:latest 
