IMAGE_NAME := homelab-home-assistant-wheels-cryptography
DOCKER_BUILD_ALLOW_INSECURE := y

include ./.bootstrap/makesystem.mk

ifeq ($(MAKESYSTEM_FOUND),1)
include $(MAKESYSTEM_BASE_DIR)/dockerfile.mk
endif
