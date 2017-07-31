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
./ktmpl -c ${CLUSTER} apply -f namespaces
./ktmpl -c ${CLUSTER} apply -f core
./ktmpl -c ${CLUSTER} apply -f dilectic
./ktmpl -c ${CLUSTER} apply -f analysis
./ktmpl -c ${CLUSTER} apply -f platform
./ktmpl -c ${CLUSTER} apply -f fringe stacks/*
```

# Dilectic hydration

```
./ktmpl -c ${CLUSTER} apply -f dilectic/hydration
```

# Stack imports

```
./ktmpl -c ${CLUSTER} apply -f platform/import stacks/*
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

1. Create a strong password:

    ```
    pwgen -1s 16
    ```

2. Record the password to the Creds spreadsheet.

3. Generate the password hash in a suitable format (note `htpasswd` uses a random salt, so this will be different every
  time you run it):

    ```
    htpasswd -n "${USERNAME}"
    ```

4. Append the output line to the `auth_secret` section of the relevant stack configuration file (in `stacks/`).

# Starting a private Python container

1. Create the box:

    ```
    ./ktmpl -c ${CLUSTER} apply -f analysis/user -e user=${GITHUB_USERNAME}
    ```

2. Port forward

    ```
    kubectl -n analysis port-forward jupyter-${GITHUB_USERNAME}-0 9022:22
    ```


## SSH-ing to the container

```
ssh -p 9022 jovyan@localhost
```

## Pushing and pulling from GitHub

To push and pull from Git, set up `ssh-agent` with forwarding by modifying `~/.ssh/config` like so:

```
Host localhost
  ForwardAgent yes
```

## Mounting container directory to local filesystem

```
mkdir ${LOCAL_FOLDER}
sshfs -p 9022 jovyan@localhost: ${LOCAL_FOLDER}
```

To unmount, run one of the following:

```
umount ${LOCAL_FOLDER}                # OSX
fusermount -u ${LOCAL_FOLDER}         # Linux
```

# Running magnolia pipeline
To kick off the pipeline job:

```
./ktmpl -c prod bounce -f analysis/jobs/magnolia-pipeline.yml
```
