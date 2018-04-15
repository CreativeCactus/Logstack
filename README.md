# Logstack

Included is `fluent.conf` which should be adjusted accordingly as it is in proof of concept state for demo purposes.

Also included is the `Dockerfile` used to generate a configured fluentd image, which depends upon `fluent.conf` and `./plugins/`.

## Fluentd/Elasticsearch/Kibana

	make start-kibana start-fluent
	docker logs -f fluent

Then once running:

	make test-log test-dlog

Elasticsearch: http://127.0.0.1:9200/fluentd

Kibana: http://127.0.0.1:5601/

## Fluentd/Elasticsearch/Grafana

	make start-grafana start-es start-fluent
	docker logs -f fluent

NOTE: If elasticsearch fails to start and `docker logs elasticsearch` gives `max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`, then do the following:

	sudo sysctl -w vm.max_map_count=262144

