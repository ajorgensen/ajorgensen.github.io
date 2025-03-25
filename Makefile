GO ?= go
GOPATH ?= $(HOME)/go
GOBIN ?= $(GOPATH)/bin

$(GOBIN)/hugo: .hugo.version
	$(GO) install github.com/gohugoio/hugo@$(shell cat .hugo.version)

setup: $(GOBIN)/hugo

.PHONY: run
default: run

run: setup
	@hugo serve -D --logLevel info
