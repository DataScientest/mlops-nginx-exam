<<<<<<< HEAD
run-project:
	# run project
	@echo "Grafana UI: http://localhost:3000"

=======
gen-model:
	python3 src/gen_model.py

start-project:
	docker compose -p mlops up -d --build
	@echo "Grafana UI: http://localhost:3000"

stop-project:
	docker compose -p mlops down

>>>>>>> 02913aa (Nginx exam correc)
test-api:
	curl -X POST "https://localhost/predict" \
     -H "Content-Type: application/json" \
     -d '{"sentence": "Oh yeah, that was soooo cool!"}' \
	 --user admin:admin \
<<<<<<< HEAD
     --insecure
=======
     --cacert ./deployments/nginx/certs/nginx.crt;

test-api-debug:
	curl -X POST "https://localhost/predict" \
     -H "Content-Type: application/json" \
	 -H "X-Experiment-Group: debug" \
     -d '{"sentence": "Oh yeah, that was soooo cool!"}' \
	 --user admin:admin \
     --cacert ./deployments/nginx/certs/nginx.crt;
>>>>>>> 02913aa (Nginx exam correc)
