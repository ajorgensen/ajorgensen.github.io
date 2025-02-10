GO ?= go
GOPATH ?= $(HOME)/go
GOBIN ?= $(GOPATH)/bin

$(GOBIN)/hugo: .hugo.version
	@echo "Installing Hugo"
	$(GO) install github.com/gohugoio/hugo@$(shell cat .hugo.version)

default: run

.PHONY: run
run: $(GOBIN)/hugo $(GOBIN)/reflex
	@hugo serve -D --verbose
