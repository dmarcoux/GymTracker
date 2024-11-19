# Partly based on https://hynek.me/articles/docker-uv

# Pull uv and Python images based on the versions passed in the build-time variables.
ARG UV_VERSION
ARG PYTHON_VERSION

################################################################################

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv
# Unlike `COPY --from=(...)`, with `FROM` we can pass a build-time variable in the image name

################################################################################

FROM python:${PYTHON_VERSION}-bookworm AS build

# The following does not work in Podman unless you build in Docker
# compatibility mode: <https://github.com/containers/podman/issues/8477>
# You can manually prepend every RUN script with `set -ex` too.
SHELL ["sh", "-exc"]

# Ensure UTF-8 encoding is used
ENV LC_CTYPE=C.utf8 \
# Silence uv complaining about not being able to use hard links
    UV_LINK_MODE=copy \
# Byte-compile packages for faster application startups
    UV_COMPILE_BYTECODE=1 \
# Prevent uv from accidentally downloading isolated Python builds
    UV_PYTHON_DOWNLOADS=never \
# Pick a Python interpreter
    UV_PYTHON=/usr/local/bin/python3 \
# Set the location of the virtual environment
    UV_PROJECT_ENVIRONMENT=/app

# Install uv from the previous stage
COPY --from=uv /uv /usr/local/bin/uv

# Synchronize dependencies without the application itself.
COPY pyproject.toml ./
COPY uv.lock ./
RUN uv sync --locked --no-dev --no-install-project

# Copy the application in `/src`, then install it without any dependencies
# This works since the application is a Python package: https://packaging.python.org/en/latest/tutorials/packaging-projects/
COPY . /src
RUN uv sync --directory=/src --locked --no-dev --no-editable

################################################################################

FROM python:${PYTHON_VERSION}-bookworm
# TODO: The resulting image from this final stage is only minimally smaller than what we use in the previous stage.
#       The difference is not having `uv` installed. It's possible to minimize this further.

SHELL ["sh", "-exc"]

# Add the virtual environment to the PATH
ENV PATH="/app/bin:$PATH"

# Create a non-root user (and automatically a group with the same name) to run the application.
RUN useradd -r --home-dir /app app

ENTRYPOINT ["/docker-entrypoint.sh"]
# See <https://hynek.me/articles/docker-signals/>.
STOPSIGNAL SIGINT

COPY docker-entrypoint.sh /

# Copy virtual environment and dependencies from the previous stage, changing their ownership to the non-root user
COPY --from=build --chown=app:app /app /app

# Default port
ENV BACKEND_PORT=8282

USER app
WORKDIR /app
