# <a href="https://github.com/dmarcoux/sports_tracker">dmarcoux/sports_tracker</a>

Track how often I do sports.

# Development Environment with devenv

Reproducible development environment based on [devenv](https://devenv.sh/). It
relies [Nix](https://github.com/NixOS/nix) a purely functional and
cross-platform package manager.

In addition to `devenv`, it is optional, but _highly recommended_ to install
[direnv](https://direnv.net/) and [setup its shell
hook](https://direnv.net/docs/hook.html) to automatically enable the development
environment when navigating to this project's root directory.

Refer to the [Makefile](./Makefile) to see various commands, like linting the
code.

# Production Environment with Docker

[Docker
images](https://github.com/dmarcoux/sports_tracker/pkgs/container/sports_tracker)
are available for _linux/amd64_ and _linux/arm64_.

## Environment Variables

Customize the application by using environment variables.

| Name | Description | Default Value |
|------|-------------|---------------|
| `BACKEND_PORT` | Configure the port for the backend application | 8282 |
