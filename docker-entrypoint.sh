#!/bin/bash

exec uvicorn backend.main:app --host 0.0.0.0 --port ${BACKEND_PORT}
