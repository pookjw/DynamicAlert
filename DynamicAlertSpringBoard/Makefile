TARGET := iphone:clang:latest
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless
export ARCHS = arm64 arm64e

TWEAK_NAME = DynamicAlertSpringBoard
$(TWEAK_NAME)_CFLAGS = -fno-objc-arc -fobjc-weak -Wno-module-import-in-extern-c -Wno-unused-variable -std=c++2b -DUSE_MS_HOOK
$(TWEAK_NAME)_FRAMEWORKS = Foundation UIKit
$(TWEAK_NAME)_FILES = $(shell find . -type f -name  "*.mm")

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
