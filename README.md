
## Server monitoring for linux and docker with Prometheus and Grafana

This is a configuration we use in production to monitor our servers and docker containers. It uses Prometheus to collect metrics and Grafana to display them.

The docker network is defined in another docker-compose (gaaspard).

Grafana and the other components may not directly be available on the internet, you 
need to publish the ports or use a reverse proxy. 

Use port forwarding to access the Grafana interface.

## How to use

At first launch, set the password in Grafana and save it. 
Then add Prometheus as a datasource in Grafana. 

Import the dashboards [893](https://grafana.com/grafana/dashboards/893-main/) for Docker 
 and [1860](https://grafana.com/grafana/dashboards/1860) for Node Exporter.

## Limitations 

The prometheus configuration is very basic and naïve, the HTTP. server monitoring does not work yet. 
There is no DB monitoring either (except for RAM / CPU of the container).