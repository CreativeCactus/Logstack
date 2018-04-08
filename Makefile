

## Example implementation of alternatie SIEM (security infra event monitoring) stack.
## Built as FOSS alternative to Splunk, on elasticsearch, kibana/grafana and fluentd.

start-kibana:
	docker run -d -p 9200:9200 -p 5601:5601 nshou/elasticsearch-kibana

start-grafana:
	docker rm -f grafana grafana-storage || true
	docker run -d -v /var/lib/grafana --name grafana-storage busybox:latest
	docker run -d -p 3000:3000 --name=grafana --volumes-from grafana-storage --net=host grafana/grafana

start-fluent:
	docker rm -f fluent ; docker build -t my-fluentd . &&  docker run --name fluent -d -p 24224:24224 -p 24224:24224/udp -v /data:/fluentd/log --net=host  -p 9880:9880  my-fluentd

test-log:
	@curl -X POST -d 'json={"foo":"bar"}' http://localhost:9880/test.tag?time=1518756037 -sw '%{http_code}\n'

test-many:
	for i in {1..100} ; do curl -X POST -d "json={\"blast\":${i}}" http://localhost:9880/test.tag ; done

test-dlog:
	docker run --log-driver=fluentd ubuntu /bin/echo 'Hello world'
