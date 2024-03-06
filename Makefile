GO ?= go
GOPATH ?= $(HOME)/go

$(GOPATH)/bin/hugo: .hugo-version
	@echo "Installing Hugo"
	$(GO) install github.com/gohugoio/hugo@$(shell cat .hugo-version)

.PHONY: run
run: $(GOPATH)/bin/hugo
	hugo server -w -D --verbose
