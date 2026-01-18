NAME = csighub.tencentyun.com/melodycchen/plantuml-server
VERSION = 1.0.0
DOCKERFILE = Dockerfile.jetty-large-headers

.PHONY: build build-version tag-latest start push shell clean

build: build-version

build-version:
	docker build -f $(DOCKERFILE) -t ${NAME}:${VERSION} .

tag-latest:
	docker tag ${NAME}:${VERSION} ${NAME}:latest

start:
	docker run -d -p 8080:8080 --name plantuml-server ${NAME}:${VERSION}

stop:
	docker stop plantuml-server
	docker rm plantuml-server

shell:
	docker run -it --rm ${NAME}:${VERSION} /bin/bash

push: build-version tag-latest
	docker push ${NAME}:${VERSION}
	docker push ${NAME}:latest

clean:
	docker rmi ${NAME}:${VERSION} ${NAME}:latest 2>/dev/null || true

logs:
	docker logs -f plantuml-server

test:
	curl -f http://localhost:8080 || echo "Server is not running"
