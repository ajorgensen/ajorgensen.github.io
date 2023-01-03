NOW=$(shell date +%Y%m%d%H%M%S)
new-post:
	@hugo new posts/$(NOW)-$(title).md

deploy:
	./deploy.sh
