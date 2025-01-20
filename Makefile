BUILD_DIR 		    := build
.DEFAULT_GOAL       := build
BUILD_DIR 		    := build
NAME 				:= loxone-prometheus-exporter
REGISTRY 			:= xcid
TAG					:= latest

.PHONY: init
init:
	go get -u github.com/onsi/ginkgo/ginkgo
	go get -u github.com/modocache/gover
	go mod download

.PHONY: lint
lint:
	golangci-lint run --config golangci.yml

.PHONY: build
build:
	env GOOS=linux go build -o $(BUILD_DIR)/exporter .

.PHONY: fmt
fmt:
	goimports -e -w -d $(shell find . -type f -name '*.go' -print)
	gofmt -e -w -d $(shell find . -type f -name '*.go' -print)

.PHONY: cover
cover:
	$(GOPATH)/bin/gover . coverage.txt

.PHONY: docker-build
docker-build:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 --tag $(NAME):latest  --push .

.PHONY: docker
docker:
	@docker build --progress=plain -t laca/loxone-prometheus-exporter .

.PHONY: push
push:
	@docker tag laca/loxone-prometheus-exporter registry.home/laca/loxone-prometheus-exporter
	@docker push registry.home/laca/loxone-prometheus-exporter
	@docker rmi registry.home/laca/loxone-prometheus-exporter
