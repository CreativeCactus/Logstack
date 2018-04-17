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

Elasticsearch: http://127.0.0.1:9200/fluentd

Grafana: http://127.0.0.1:3000/datasources/new?gettingstarted

Log in with admin:admin.

To get started, create an elasticsearch data source with `http://elasticsearch:9200`, access: proxy, index name: fluentd, Time field name: created, Version: 5.6+.

Note that this field will not exist unless data is present. Use `make test-log test-dlog` to try that.

If all goes well, go to `+ -> Create Dashboard -> Graph` and leave most things as default. You should end up with a graph of events over time.

## Grafana with rasPi

Then, you can access your Grafana dashboards for presentation on a rasPi using the following steps: http://docs.grafana.org/guides/whats-new-in-v2/#server-side-panel-rendering

Here is an example of a simple script for presenting these individual panels over ssh. Note that timeout and pull loops should be synchronised to avoid skipping graphs that fail to load due to being writting to.

Note basic auth and warning about having at least 3 images BEFORE running fbi, as it will not detect files CREATED after running.

```
echo "Note that FBI with <3 images will cache regardless, and should be rebooted from the loop. Use symlinks to display a single updating image"
sudo killall fbi ; sudo fbi -a -v -T 2 -t 5 -noverbose -cachemem 0 ./dash/*.png &
while true; do
        curl "http://admin:pass@192.168.103.108:3000/render/d-solo/kVNOyvWik/dash?orgId=1&panelId=2&width=1000&height=500&tz=UTC%2B10%3A00" > dash/list.png
        curl "http://admin:pass@192.168.103.108:3000/render/d-solo/kVNOyvWik/dash?orgId=1&panelId=4&width=1000&height=500&tz=UTC%2B10%3A00" > dash/mppdf.png
        sleep 10
done
```