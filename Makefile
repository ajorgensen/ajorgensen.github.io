GO ?= go
GOPATH ?= $(HOME)/go
GO_VERSION = 1.19

$(GOPATH)/bin/hugo:
	$(GO) install github.com/gohugoio/hugo@v0.108.0

HOMEBREW_PREFIX ?= /usr/local
HOMEBREW_BIN = $(HOMEBREW_PREFIX)/bin

#npm install -g postcss-cli
deps: $(GOPATH)/bin/hugo

serve:
	hugo serve --disableFastRender --buildDrafts

deploy:
	./deploy.sh

build:
	@hugo --minify

NOW=$(shell date +%Y%m%d%H%M%S)
new-post:
	@hugo new posts/$(NOW)-$(title).md

test:
	@echo $(CURRENT_POST_FOLDER)