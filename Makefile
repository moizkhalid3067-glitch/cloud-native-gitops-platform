.PHONY: install test run docker-build docker-run kind-create deploy status logs clean

install:
	python -m pip install -r requirements-dev.txt

test:
	python -m pytest -q

run:
	uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

docker-build:
	docker build -t platform-demo:local .

docker-run:
	docker run --rm -p 8000:8000 platform-demo:local

kind-create:
	kind create cluster --name platform-lab --config kind/cluster.yaml

deploy:
	kubectl apply -k k8s/overlays/local

status:
	kubectl get all -n platform-demo

logs:
	kubectl logs -n platform-demo deploy/platform-demo

clean:
	kind delete cluster --name platform-lab
