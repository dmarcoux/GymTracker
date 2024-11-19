from pathlib import Path

from starlette.config import Config

# Config will read first from environment variables, then from the `.env` file at the git repository's root
config = Config(".env")

# Static files
DEFAULT_STATIC_DIR = Path(__file__).parent / "static"
STATIC_DIR = config("STATIC_DIR", default=DEFAULT_STATIC_DIR)

# Template files
DEFAULT_TEMPLATES_DIR = Path(__file__).parent / "templates"
TEMPLATES_DIR = config("TEMPLATES_DIR", default=DEFAULT_TEMPLATES_DIR)

# Cross-Origin Resource Sharing (CORS)
DEFAULT_ORIGIN_FRONTEND = "http://0.0.0.0:3000"
ORIGIN_FRONTEND = config("ORIGIN_FRONTEND", default=DEFAULT_ORIGIN_FRONTEND)
