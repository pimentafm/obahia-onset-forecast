# Build docker image
BUILDNAME=obahia
BUILDTAG=onsetforecast

gen-onset-image:
	docker build -t "$(BUILDNAME):$(BUILDTAG)" -f Dockerfile .

run-onset-container:
	docker run --rm --privileged=true -e tz=america/sao_paulo -v $(shell pwd):/onset-forecast:rw $(BUILDNAME):$(BUILDTAG)
