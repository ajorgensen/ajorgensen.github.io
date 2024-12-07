GO ?= go
GOPATH ?= $(HOME)/go
GOBIN ?= $(GOPATH)/bin

$(GOBIN)/hugo: .hugo.version
	@echo "Installing Hugo"
	$(GO) install github.com/gohugoio/hugo@$(shell cat .hugo.version)

$(GOBIN)/reflex: .reflex.version
	$(GO) install github.com/cespare/reflex@$(shell cat .reflex.version)

default: run

.PHONY: run
run: $(GOBIN)/hugo $(GOBIN)/reflex
	@reflex -c reflex.conf --verbose
