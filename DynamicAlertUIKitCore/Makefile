TARGET := iphone:clang:latest
THEOS_PACKAGE_SCHEME = rootless
export ARCHS = arm64 arm64e

TWEAK_NAME = DynamicAlertUIKitCore
$(TWEAK_NAME)_CFLAGS = -fno-objc-arc -fobjc-weak -Wno-module-import-in-extern-c -Wno-unused-variable -std=c++2b -DUSE_MS_HOOK -Wno-nullability-completeness
$(TWEAK_NAME)_FRAMEWORKS = Foundation UIKit
$(TWEAK_NAME)_FILES = $(shell find . -type f -name  "*.mm")

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
