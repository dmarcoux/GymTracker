.PHONY: dev format lint test tag

# Run the FastAPI application in development mode
dev:
	uv run fastapi dev src/sports_tracker/main.py

# Format the Python code
format:
	uv run ruff format

# Lint the Python code
lint:
	uv run ruff check --show-fixes --fix

# Run tests
test:
	uv run pytest

# Create and push a tag, with its name being the project's version from pyproject.toml
tag:
	@if [ -z "$(MESSAGE)" ]; then \
		echo 'A message is required for the Git tag. Try again with `MESSAGE="My tag message" make tag`.'; \
	else \
		VERSION=$(shell uv run - <<< 'import tomllib; print(tomllib.load(open("pyproject.toml", "rb"))["project"]["version"])'); \
		git tag --annotate $$VERSION --message "$(MESSAGE)"; \
		git push origin tag $$VERSION; \
	fi
