.PHONY: install run-health run-migrate run-scale test clean

install:
	pip install boto3 psycopg2-binary pymongo

run-health:
	python python/monitor_server_health.py

run-migrate:
	python python/pg2mongo.py

run-scale:
	python python/eb_update_config.py

test:
	@echo "Running script syntax checks..."
	bash -n shell/backend_server.sh
	bash -n shell/frontend_service.sh
	bash -n shell/docker_deployment.sh
	bash -n shell/jenkins_service.sh
	bash -n shell/mongo_service.sh
	bash -n shell/server_status.sh
	bash -n shell/code_deploy.sh
	bash -n shell/delete_autoscaling_policies.sh
	@echo "All scripts pass syntax check."

clean:
	rm -rf __pycache__ *.pyc *.pyo
