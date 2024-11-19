.PHONY: backend frontend format lint up down logs test tag

# Run the FastAPI backend in development mode. Rely on `up` if the whole application
# is needed. It runs all the required processes for the application (frontend, backend, etc...)
backend:
	uv run fastapi dev src/backend/main.py

# Run the React frontend in development mode. Rely on `up` if the whole application
# is needed. It runs all the required processes for the application (frontend, backend, etc...)
frontend:
	npm run dev --prefix src/frontend

# Format the Python code
format:
	uv run ruff format

# Lint the Python code
lint:
	uv run ruff check --show-fixes --fix

# Start devenv processes
up:
	devenv processes up --detach

# Stop devenv processes
down:
	devenv processes down

# See the logs of devenv processes
logs:
	tail -f .devenv/processes.log

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
