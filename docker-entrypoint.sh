#!/bin/bash

exec uvicorn sports_tracker.main:app --host 0.0.0.0 --port 8000
