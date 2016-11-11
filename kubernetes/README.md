
# Alerting
To checkout the Prometheus/AlertManager UIs in the event of an outage:

 1. Find out the IP of one of the Kubernetes cluster boxes.
 2. Create ssh tunnels:

      ssh -fnNT -L 32220:localhost:32220 -L 32221:localhost:32221 <IP>
