# Build a docker image based on fedora rawhide with apache and mapserver
BUILDNAME=onset
BUILDTAG=test

CONTAINERNAME=onset-forecast

onset-image:
	docker build -t "$(BUILDNAME):$(BUILDTAG)" -f Dockerfile .

run-container:
	docker run --rm --privileged=true -e tz=america/sao_paulo -v $(shell pwd):/onset-forecast:rw $(BUILDNAME):$(BUILDTAG)
