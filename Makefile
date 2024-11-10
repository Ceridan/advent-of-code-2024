##############################################################################
# Set up
##############################################################################
.PHONY: install
install: deps direnv

.PHONY: deps
deps: # Install dependencies
	luarocks install --deps-only advent-of-code-2024-dev-1.rockspec
	luarocks lint advent-of-code-2024-dev-1.rockspec

.PHONY: direnv
direnv: # Set environment varaibales
	direnv allow .

##############################################################################
# Development
##############################################################################
.PHONY: format
format: # Format code
	@lua-format --in-place src/*.lua

.PHONY: lint
lint: # Static code analysis
	@luacheck src

.PHONY: exec
exec: # Run day XX
	@lua src/day$(day).lua

.PHONY: gen
gen: # Generate next day
	@scripts/next_day_gen.sh $(day)
