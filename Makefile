.PHONY: format lint

# Format the Python code
format:
	uv run ruff format

# Lint the Python code
lint:
	uv run ruff check --show-fixes --fix
