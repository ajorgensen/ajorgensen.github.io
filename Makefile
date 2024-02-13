default: build

GO ?= go
GOPATH ?= $(HOME)/go

$(GOPATH)/bin/hugo: .hugo-version
	@echo "Installing Hugo"
	@CGO_ENABLED=1 $(GO) install -tags extended github.com/gohugoio/hugo@$(shell cat .hugo-version)

.PHONY: build
build: $(GOPATH)/bin/hugo
	hugo 

.PHONY: clean
clean:
	rm -rf public

.PHONY: serve
serve:
	hugo server -w -D
