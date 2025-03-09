GO ?= go
GOPATH ?= $(HOME)/go
GOBIN ?= $(GOPATH)/bin

$(GOBIN)/hugo: .hugo.version
	$(GO) install github.com/gohugoio/hugo@$(shell cat .hugo.version)

$(GOBIN)/reflex:
	$(GO) install github.com/cespare/reflex@$(shell cat .reflex.version)
	
default: run

setup: $(GOBIN)/hugo $(GOBIN)/reflex

.PHONY: run
run: setup
	@hugo serve -D --logLevel info
