In the following instructions, `${CLUSTER}` is the cluster name (`dev`, `prod`, etc.).

# Prerequisites

- Python3 virtualenv:

    ```
    virtualenv .env --python=`which python3`
    source .env/bin/activate
    pip install -r requirements.txt
    ```

# Bootstrap

1. Create a Container Engine cluster and persistent disk:

    ```
    ./scripts/create-cluster.sh ${CLUSTER} ${NUM_NODES}
    ```

# Starting the cluster

```
./ktmpl -c ${CLUSTER} -o apply -f namespaces stacks/*
./ktmpl -c ${CLUSTER} -o apply -f core
./ktmpl -c ${CLUSTER} -o apply -f dilectic
./ktmpl -c ${CLUSTER} -o apply -f analysis
./ktmpl -c ${CLUSTER} -o apply -f platform stacks/*
```

# Dilectic hydration

```
./ktmpl -c ${CLUSTER} -o apply -f dilectic/hydration
```

# Stack imports

```
./ktmpl -c ${CLUSTER} -o apply -f platform/import stacks/*
```

# Per-stack operations

Any of the multi-stack operations above can be applied in a more granular way by providing specific stack definitions.
For example:

```
./ktmpl -c ${CLUSTER} apply -f platform/import stacks/alpha.yml
```

# Alerting
To checkout the Prometheus/AlertManager UIs in the event of an outage:

1. Find out the IP of one of the Kubernetes cluster boxes.
2. Create ssh tunnels:

    ```
    ssh -fnNT -L 32220:localhost:32220 -L 32221:localhost:32221 <IP>
    ```

# Adding dashboards

**Note:** This procedure is still pretty ropy.

1. Create dashboard in Grafana UI.

2. Export dashboard (Cog icon -> Export).

3. Move to `core/dashboards/` directory.

4. Add `{ "dashboard": XXX, overwrite: false }` surrounding structure. Set id to null.

5. Run:

    ```
    kubectl -n core delete cm grafana-dashboards
    kubectl -n core create cm grafana-dashboards --from-file=core/dashboards
    kubectl -n core get cm grafana-dashboards -o yaml > core/grafana-dashboards.yml
    ```

6. Remove guff in metadata except for `name` and `namespace`.
7. Do normal Git stuff.

# Creating basic-auth passwords

```
htpasswd -c ${STACK_NAME} | base64
```

# Starting a private Python container
1. Create the box:

```
./ktmpl -c ${CLUSTER} apply -f analysis/user -e user=${GITHUB_USERNAME}
```

2. Port forward

```
kubectl -n analysis port-forward jupyter-${GITHUB_USERNAME}-0 9022:22
```

3. SSH to the box:

```
ssh -p 9022 jovyan@localhost
```

To push and pull from git, set up `ssh-agent` with forwarding.

