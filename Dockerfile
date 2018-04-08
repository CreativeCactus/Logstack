FROM 	fluent/fluentd:v1.1.3-debian-onbuild
# ONBUILD COMMANDS RUN HERE:
RUN 	fluent-gem install fluent-plugin-elasticsearch
EXPOSE 	9880

