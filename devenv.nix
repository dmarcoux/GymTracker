# https://devenv.sh/reference/options/
{ pkgs, lib, config, inputs, ... }:

let
  # Anything which is referenced multiple times is defined as a variable here...
  # To install packages from nixpkgs-unstable - https://search.nixos.org/packages?channel=unstable
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };

  # Locales
  glibcLocales = pkgs.glibcLocales;

  # Bundle of SSL certificates
  cacert = pkgs.cacert;
in
{
  # Set environment variables
  env = {
    # Set LANG for locales
    LANG = "C.UTF-8";

    # Remove duplicate commands from Bash shell command history
    HISTCONTROL = "ignoreboth:erasedups";

    # Without this, there are warnings about LANG, LC_ALL and locales.
    # Many tests fail due those warnings showing up in test outputs too...
    # This solution is from: https://gist.github.com/aabs/fba5cd1a8038fb84a46909250d34a5c1
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

    # For the bundle of SSL certificates to be used in applications (like curl and others...)
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # Install packages - https://devenv.sh/packages/
  packages = with pkgs; [
    # Timezones
    tzdata
    # Locales
    glibcLocales
    # Bundle of SSL certificates
    cacert
  ];

  # Setup languages and their tools - https://devenv.sh/languages/
  # https://devenv.sh/supported-languages/python/
  languages.python = {
    enable = true;
    version = "3.12.7";
    # Enable uv, an extremely fast Python package and project manager - https://docs.astral.sh/uv/
    uv = {
      enable = true;
      package = pkgs-unstable.uv;
      # Sync the project's dependencies (from `pyproject.toml`) with the virtual environment
      sync.enable = true;
    };
    # Enable Python virtual environment. It's created with `uv venv`.
    venv.enable = true;
  };
  languages.javascript = {
    enable = true;
    # Node.js Active LTS
    package = pkgs-unstable.nodejs-slim_22;
    # Setup npm
    npm.enable = true;
  };

  # https://devenv.sh/processes/
  processes = {
    # Run the FastAPI backend in development mode
    backend = {
      exec = "make backend";
    };

    # Run the React frontend in development mode
    frontend = {
      exec = "make frontend";
    };

    # TailwindCSS watches for changes in styles and regenerates the CSS as needed
    tailwindcss = {
      # TODO: This should be relying on STATIC_DIR from config.py for `--input` and `--output`
      exec = "tailwindcss --config tailwind.config.js --input static/styles/main.css --output static/css/main.css --watch";
      # Configure how the process is executed
      process-compose = {
        # Set working directory
        working_dir = "src/frontend";
        # Certain processes check if they are running within a terminal, so in this case we need to simulate a TTY mode
        is_tty = true;
      };
    };
  };

  # https://devenv.sh/tasks/
  tasks = {
    "uv:version" = {
      description = "Put uv's version in `.uv-version`. This file is used in CI.";
      exec = "uv version | cut --delimiter=' ' --fields=2 > .uv-version";
      after = [ "devenv:python:uv" ]; # Our task runs after this
      before = [ "devenv:enterShell" ]; # Our task runs before this
    };

    "python:version" = {
      description = "Put Python's version in `.python-version`. This file is used in CI.";
      exec = "python --version | cut --delimiter=' ' --fields=2 > .python-version";
      after = [ "devenv:python:uv" ]; # Our task runs after this
      before = [ "devenv:enterShell" ]; # Our task runs before this
    };
    # TODO: Do the same for ruff.toml's target-version. Maybe combine this with `sed`: python --version | cut --delimiter=" " --fields=2 | cut --delimiter="." --fields=1,2 --output-delimiter="" | sed ...

    "venv:patchelf-ruff" = {
      description = "Patch ruff binary. It is dynamically linked to ld, which will not work with Nix";
      exec = "${lib.getExe pkgs.patchelf} --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} $VIRTUAL_ENV/bin/ruff";
      after = [ "devenv:python:uv" ]; # Our task runs after this
      before = [ "devenv:enterShell" ]; # Our task runs before this
    };
  };
}
