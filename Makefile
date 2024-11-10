.PHONY: dev format lint test

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
