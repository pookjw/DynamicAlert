#!/bin/sh

xcrun simctl spawn booted launchctl debug system/com.apple.SpringBoard --environment DYLD_INSERT_LIBRARIES=$(cat /Users/pookjw/Desktop/path):/Users/pookjw/Desktop/RevealServer/RevealServer.xcframework/ios-arm64_x86_64-simulator/RevealServer.framework/RevealServer

xcrun simctl spawn booted launchctl stop com.apple.SpringBoard
