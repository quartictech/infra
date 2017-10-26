In the following instructions, `${CLUSTER}` is the cluster name (`dev`, `prod`, etc.).

# Prerequisites

- Python3 virtualenv:

    ```
    virtualenv .env --python=`which python3`
    source .env/bin/activate
    pip install -r requirements.txt
    ```


# Bootstrap

1. Create a Container Engine cluster via Terraform.

2. Deploy the master keys:

    ```
    kubectl create secret generic -n platform secrets --from-file=master_key_base64=master-key-platform
    kubectl create secret generic -n fringe secrets --from-file=master_key_base64=master-key-fringe
    ```

3. [Enable network-policy enforcement][1] (**note:** this won't be required once we can do this via Terraform).

    - Give yourself the **Container Engine Cluster Admin** role via GCloud console (or CLI).

    - Add the `NetworkPolicy` add-on (this will add Calico stuff to the cluster):

        ```
        gcloud beta container clusters update ${CLUSTER} \
            --project ${PROJECT_ID} --zone ${ZONE} \
            --update-addons NetworkPolicy=ENABLED
        ```

    - Enable enforcement (this will recreate the node pools):

        ```
        gcloud beta container clusters update ${CLUSTER} \
            --project ${PROJECT_ID} --zone ${ZONE} \
            --enable-network-policy
        ```

    - Remove the **Container Engine Cluster Admin** role.


[1]: https://cloud.google.com/container-engine/docs/network-policy#enabling_network_policy_enforcement


# Starting the cluster

```
./ktmpl -c ${CLUSTER} apply -f namespaces
./ktmpl -c ${CLUSTER} apply -f core
./ktmpl -c ${CLUSTER} apply -f dilectic
./ktmpl -c ${CLUSTER} apply -f analysis
./ktmpl -c ${CLUSTER} apply -f platform
./ktmpl -c ${CLUSTER} apply -f fringe
```


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

4. Append the output line to the `auth_secret` section of the relevant stack configuration file (in `config/clusters/`).


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


# Postgres major-version upgrades

1. Spin up new stateful set.
2. Stop platform services.
3. Port-forward to both Postgres versions:

   ```
   kubectl port-forward -n platform ${POSTGRES_OLD_POD} 5432:5432 &
   kubectl port-forward -n platform ${POSTGRES_NEW_POD} 5433:5432 &
   ```

3. Run database dump:

    ```
    pg_dumpall -h localhost -p 5432 -U postgres > dump.sql
    ```

4. Run database hydration:

   ```
   cat dumps/dump.sql | psql -h localhost -p 5433 -U postgres -d postgres -q
   ```

5. Delete old stateful set.
6. Rename service for new stateful set.
7. Start platform services.
8. Delete PVC:

   ```
   kubectl get pv
   kubectl delete pv ${PVC_NAME}
   ```

9. Delete disk via GCloud console.
