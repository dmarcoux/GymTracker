#!/bin/bash

exec uvicorn sports_tracker.main:app --host 0.0.0.0 --port ${SPORTS_TRACKER_PORT}
