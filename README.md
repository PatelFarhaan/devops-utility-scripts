# DevOps Scripts Collection

A curated collection of Python, Shell, and YAML scripts for common DevOps tasks including server provisioning, monitoring setup, database migration, deployment automation, and infrastructure management on AWS.

## Tech Stack

- Python 3 (boto3, psycopg2, pymongo)
- Bash
- Docker
- AWS (Elastic Beanstalk, Auto Scaling, CodeDeploy, S3)
- MongoDB
- PostgreSQL
- Prometheus / Grafana
- Jenkins
- Nginx
- Supervisor

## Features

### Python Scripts
- **eb_update_config.py** -- Dynamically scale AWS Elastic Beanstalk Auto Scaling Groups by adjusting desired and max instance counts
- **monitor_server_health.py** -- Collect system health metrics (CPU load, RAM usage, disk space, network latency) on macOS
- **pg2mongo.py** -- Migrate data from PostgreSQL tables to MongoDB collections with pagination support

### Shell Scripts
- **backend_server.sh** -- Provision an Ubuntu server with Python, virtualenv, Gunicorn, Supervisor, and Nginx for a Flask backend
- **frontend_service.sh** -- Provision an Ubuntu server with Node.js, Supervisor, and Nginx for a React frontend
- **backend_frontend_monolith.sh** -- Combined provisioning script for both backend and frontend on a single server
- **docker_deployment.sh** -- Build and deploy frontend and backend Docker containers with cleanup
- **jenkins_service.sh** -- Deploy Jenkins via Docker with plugin auto-installation
- **mongo_service.sh** -- Deploy MongoDB via Docker with authentication enabled
- **server_status.sh** -- Full monitoring stack setup: Docker, Grafana, Prometheus, Jenkins, MongoDB, cAdvisor, Node Exporter, and Nginx Exporter
- **code_deploy.sh** -- Install AWS CodeDeploy agent on Ubuntu
- **delete_autoscaling_policies.sh** -- Remove all Auto Scaling policies from an Elastic Beanstalk environment

### YAML Configuration
- **prometheus.yml** -- Prometheus scrape configuration for Jenkins, Node Exporter, and cAdvisor

## Prerequisites

- Python 3.6 or higher (for Python scripts)
- Bash shell (for shell scripts)
- AWS CLI configured (for AWS-related scripts)
- Docker (for container deployment scripts)

## Installation and Setup

```bash
git clone <repository-url>
cd scripts
cp .env.example .env
# Edit .env with your actual credentials
```

For Python scripts:
```bash
pip install boto3 psycopg2-binary pymongo
```

## Environment Variables

| Variable | Description | Used By |
|----------|-------------|---------|
| `AWS_ACCESS_KEY_ID` | AWS access key | eb_update_config.py |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | eb_update_config.py |
| `AWS_REGION` | AWS region | eb_update_config.py |
| `PG_DATABASE` | PostgreSQL database name | pg2mongo.py |
| `PG_USER` | PostgreSQL username | pg2mongo.py |
| `PG_PASSWORD` | PostgreSQL password | pg2mongo.py |
| `PG_HOST` | PostgreSQL host | pg2mongo.py |
| `PG_PORT` | PostgreSQL port | pg2mongo.py |
| `MONGO_URI` | MongoDB connection URI | pg2mongo.py |
| `MONGO_DATABASE` | MongoDB target database | pg2mongo.py |
| `MONGO_USERNAME` | MongoDB admin username | mongo_service.sh |
| `MONGO_PASSWORD` | MongoDB admin password | mongo_service.sh |
| `JENKINS_METRICS_USERNAME` | Jenkins metrics username | prometheus.yml |
| `JENKINS_METRICS_PASSWORD` | Jenkins metrics password | prometheus.yml |
| `GRAFANA_USERNAME` | Grafana admin username | server_status.sh |
| `GRAFANA_PASSWORD` | Grafana admin password | server_status.sh |

## How to Run

### Python Scripts
```bash
python python/monitor_server_health.py
python python/pg2mongo.py
python python/eb_update_config.py
```

### Shell Scripts
```bash
chmod +x shell/*.sh
bash shell/backend_server.sh
bash shell/mongo_service.sh
bash shell/server_status.sh
```

## Project Structure

```
scripts/
├── python/
│   ├── eb_update_config.py         # AWS Auto Scaling Group management
│   ├── monitor_server_health.py    # System health metrics collection
│   └── pg2mongo.py                 # PostgreSQL to MongoDB migration
├── shell/
│   ├── backend_server.sh           # Backend server provisioning
│   ├── frontend_service.sh         # Frontend server provisioning
│   ├── backend_frontend_monolith.sh # Combined server provisioning
│   ├── docker_deployment.sh        # Docker container deployment
│   ├── jenkins_service.sh          # Jenkins Docker setup
│   ├── mongo_service.sh            # MongoDB Docker setup
│   ├── server_status.sh            # Full monitoring stack setup
│   ├── code_deploy.sh              # AWS CodeDeploy agent setup
│   └── delete_autoscaling_policies.sh # Auto Scaling policy cleanup
├── yaml/
│   └── prometheus.yml              # Prometheus scrape configuration
├── .env.example                    # Environment variable template
└── .gitignore
```

## License

MIT
