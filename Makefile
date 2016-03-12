requests:
	@echo "Building Requests"
	@swift build

test: requests
	@.build/debug/spectre-build
