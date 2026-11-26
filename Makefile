.PHONY: build up down start stop logs bash jupyter notebook test clean push

# Default target
help:
	@echo "Masters Thesis Docker Operations"
	@echo "================================"
	@echo "make build        - Build Docker images"
	@echo "make up           - Start containers in background"
	@echo "make down         - Stop and remove containers"
	@echo "make start        - Start existing containers"
	@echo "make stop         - Stop containers"
	@echo "make logs         - View container logs"
	@echo "make bash         - Open bash shell in container"
	@echo "make jupyter      - Start JupyterLab in foreground"
	@echo "make notebook     - Open Jupyter notebook interface"
	@echo "make test         - Test environment (check Python and imports)"
	@echo "make clean        - Clean up Docker resources"
	@echo "make push         - Push image to GitHub Container Registry"

# Build Docker images
build:
	docker compose build

# Start containers in background
up:
	docker compose up -d --build

# Stop containers
down:
	docker compose down

# Start existing containers
start:
	docker compose start

# Stop containers
stop:
	docker compose stop

# View logs
logs:
	docker compose logs -f --tail=100

# Open bash shell in container
bash:
	docker compose exec thesis-jupyter bash

# Run JupyterLab (foreground)
jupyter:
	docker compose up

# Open Jupyter notebook via browser
notebook:
	@echo "Open http://localhost:8888 in your browser"
	docker compose up

# Test environment
test:
	docker compose run --rm thesis-jupyter python -c "import sys; print(f'Python {sys.version}'); import ortools; import pandas; import sklearn; import xgboost; print('All imports successful!')"
	docker compose run --rm thesis-jupyter python -c "from ortools.constraint_solver import pywrapcp, routing_enums_pb2; print('OR-Tools OK')"

# Clean up Docker resources
clean:
	docker compose down -v --remove-orphans
	docker image prune -f
	docker system prune -f

# Push to GitHub Container Registry
push:
	docker tag masters-thesis-jupyter ghcr.io/$(shell git config --get remote.origin.url | sed 's|.*/\([^/]*\)\.git|\1|' | tr 'A-Z' 'a-z')/masters-thesis-jupyter:latest
	docker push ghcr.io/$(shell git config --get remote.origin.url | sed 's|.*/\([^/]*\)\.git|\1|' | tr 'A-Z' 'a-z')/masters-thesis-jupyter:latest