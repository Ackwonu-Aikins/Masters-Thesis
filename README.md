# Masters Thesis - Container Documentation

This document provides instructions for running your thesis code in a Docker container.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 1.29+ (or Docker Compose V2)

## Quick Start

```bash
# Build and start JupyterLab
make up

# Or using docker-compose directly
docker compose up -d --build
```

## Available Commands

Use `make help` to see all available commands:

| Command | Description |
|---------|-------------|
| `make build` | Build Docker images |
| `make up` | Start containers in background |
| `make down` | Stop and remove containers |
| `make bash` | Open bash shell in container |
| `make jupyter` | Start JupyterLab in foreground |
| `make test` | Test environment setup |
| `make clean` | Clean up Docker resources |

## Accessing JupyterLab

1. After running `make up`, open http://localhost:8888 in your browser
2. No authentication token is required (set in docker-compose.yml)
3. Navigate to the `CODES` directory to access your notebooks

## Project Structure

```
MASTERS_THESIS/
├── CODES/
│   ├── Thesis phase I/       # CVRP, TSP, VRPTW notebooks
│   ├── Thesis phase II/      # Model training notebooks
│   ├── Thesis phase III/     # Results and evaluation
│   └── Thesis files/         # Core analysis notebooks
├── docker/
│   ├── Dockerfile            # Multi-stage build
│   ├── entrypoint.sh         # Container initialization
│   └── .dockerignore         # Build exclusions
├── docker-compose.yml        # Container orchestration
├── Makefile                  # Convenience commands
└── requirements.txt          # Python dependencies
```

## Development Workflow

1. **Run notebooks**: Access JupyterLab at http://localhost:8888
2. **Execute code**: Run cells as in standard JupyterLab
3. **Data persistence**: 
   - CODES directory is mounted read-only
   - Use `/app/notebook-data` for any writable output
4. **Terminal access**: Use `make bash` to open a shell

## Shipping to GitHub

The container is ready to be pushed to GitHub Container Registry (ghcr.io). 

To push:
```bash
# Login to GitHub Container Registry
echo $GHCR_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Build and tag
docker build -t ghcr.io/ackwonu-aikins/masters-thesis-jupyter:latest .

# Push
docker push ghcr.io/ackwonu-aikins/masters-thesis-jupyter:latest
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `JUPYTER_ENABLE_LAB` | `yes` | Enable JupyterLab |
| `JUPYTER_TOKEN` | `` | Disable authentication |

### Port Mappings

- Host: 8888 → Container: 8888 (JupyterLab)

## Testing

Run the test suite to verify the environment:
```bash
make test
```

This verifies:
- Python version
- Required package imports (ortools, pandas, sklearn, xgboost)
- OR-Tools functionality

## Notes

- The container uses Python 3.11-slim for a minimal footprint
- All dependencies from `requirements.txt` are installed
- OR-Tools is available for VRP optimization
- JupyterLab extensions are pre-installed