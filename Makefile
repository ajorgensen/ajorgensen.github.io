GO ?= go
GOPATH ?= $(HOME)/go
GO_VERSION = 1.18

#$(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.2
$(GOPATH)/bin/hugo:
	$(GO) install github.com/gohugoio/hugo@v0.95.0

HOMEBREW_PREFIX ?= /usr/local
HOMEBREW_BIN = $(HOMEBREW_PREFIX)/bin

$(HOMEBREW_BIN)/firebase-cli:
	brew install firebase-cli

deps: $(GOPATH)/bin/hugo $(HOMEBREW_BIN)/firebase-cli

serve:
	open "http://localhost:1313"
	hugo serve --buildDrafts

deploy:
	./deploy.sh
