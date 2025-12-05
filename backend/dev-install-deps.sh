#!/bin/bash
# Quick script to install new dependencies without rebuilding
docker-compose exec web pip install -r requirements.txt
docker-compose restart web celery
