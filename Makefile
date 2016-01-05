SWIFTC=swiftc

ifeq ($(shell uname -s), Darwin)
XCODE=$(shell xcode-select -p)
SDK=$(XCODE)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
TARGET=x86_64-apple-macosx10.10
SWIFTC=swiftc -target $(TARGET) -sdk $(SDK) -Xlinker -all_load
endif

SPECS=URL HTTPParser SendResponse
SPEC_FILES=$(foreach spec,$(SPECS),Tests/$(spec)Spec.swift)

requests:
	@echo "Building Requests"
	@swift build

run-tests: requests Tests/main.swift $(SPEC_FILES)
	@echo "Building specs"
	@$(SWIFTC) -o run-tests \
		Tests/main.swift \
		$(SPEC_FILES) \
		-I.build/debug \
		-Xlinker .build/debug/Spectre.a \
		-Xlinker .build/debug/Requests.a \
		-Xlinker .build/debug/Inquiline.a \
		-Xlinker .build/debug/Nest.a

test: run-tests
	./run-tests
