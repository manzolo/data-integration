CONTAINER_NAME=data-integration
IMAGE=manzolo/$(CONTAINER_NAME)
APP=spoon

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  help\t\tPrint this help"
	@echo "  test\t\tLookup for docker and docker-compose binaries"
	@echo "  setup\t\tBuild docker images"
	@echo "  run [app]\tRun app defined in '\$$APP' (spoon by default)"
	@echo ""
	@echo "Example: make run APP=spoon"

.PHONY: test
test:
	@which docker
	@which docker-compose
	@which xauth
	docker container run --rm --name $(CONTAINER_NAME) -v `pwd`/jobs:/jobs -v `pwd`/libs:/libs $(IMAGE) runj dummy.kjb

.PHONY: setup
setup: Dockerfile
	docker image build -t $(IMAGE) .

.PHONY: run
run:
	@echo $(APP)
	docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
	--name $(CONTAINER_NAME) \
	-v `pwd`/jobs:/jobs \
	-v `pwd`/libs:/libs \
	-e XAUTH=$$(xauth list|grep `uname -n` | cut -d ' ' -f5) -e "DISPLAY" \
       	$(IMAGE) $(APP)
       	
#docker container run --rm --name data-integration -v `pwd`/jobs:/jobs -v `pwd`/libs:/libs manzolo/data-integration runj dummy.kjb -param:PARAMETER_NAME=PARAMETER_VALUE

