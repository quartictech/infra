# Prerequisites

- [ktmpl](https://github.com/InQuicker/ktmpl):

        brew install rust
        cargo install ktmpl
        export PATH=${PATH}:~/.cargo/bin    # Should probably go in your .bashrc/.zshrc file


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

# Starting the Cluster

    kubectl apply -f namespaces
    ktmpl ingress/ingress.template.yml -p DOMAIN_NAME dev.quartic.io | kubectl apply -f -
    kubectl apply -f core
    kubectl apply -f dilectic
    kubectl apply -f platform
    kubectl apply -f platform/import

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
