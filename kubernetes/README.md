# Prerequisites

- Python3 virtualenv:

        virtualenv .env --python=`which python3`
        source .env/bin/activate
        pip install -r requirements.txt

# Bootstrap

1. Create a Container Engine cluster either via the Google Console or on the command line:

        gcloud container clusters create <my-cluster>

2. Grab the credentials for kubernetes to connected

        gcloud container clusters get-credentials

3. Login with application default creds for some weird reason:

        gcloud auth application-default login

4. Should be good to go. Run `kubectl get events` or something to test.
5. You might need to manually add the postgres disk to the cluster machine?
6. Open HTTP port on the primary node
7. Add our external IP to the primary node
8. Label it with `ingressNode=true`

        kubectl label nodes <node> ingressNode=true

# Starting the cluster

    export DOMAIN_NAME=dev.quartic.io   # Or whatever the relevant domain is

    ./ktmpl -d ${DOMAIN_NAME} -o apply -f namespaces stacks/*
    ./ktmpl -d ${DOMAIN_NAME} -o apply -f core
    ./ktmpl -d ${DOMAIN_NAME} -o apply -f dilectic
    ./ktmpl -d ${DOMAIN_NAME} -o apply -f platform stacks/*

# Dilectic hydration

    ./ktmpl -d ${DOMAIN_NAME} -o apply -f dilectic/hydration

# Stack imports

    ./ktmpl -d ${DOMAIN_NAME} -o apply -f platform/import stacks/*

# Alerting
To checkout the Prometheus/AlertManager UIs in the event of an outage:

1. Find out the IP of one of the Kubernetes cluster boxes.
2. Create ssh tunnels:

        ssh -fnNT -L 32220:localhost:32220 -L 32221:localhost:32221 <IP>

# Adding dashboards

**Note:** This procedure is still pretty ropy.

1. Create dashboard in Grafana UI.

2. Export dashboard (Cog icon -> Export).

3. Move to `core/dashboards/` directory.

4. Add `{ "dashboard": XXX, overwrite: false }` surrounding structure. Set id to null.

5. Run:

        kubectl -n core delete cm grafana-dashboards
        kubectl -n core create cm grafana-dashboards --from-file=core/dashboards
        kubectl -n core get cm grafana-dashboards -o yaml > core/grafana-dashboards.yml

6. Remove guff in metadata except for `name` and `namespace`.
7. Do normal Git stuff.
