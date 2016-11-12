
# Bootstrap
 1. Create a Container Engine cluster either via the Google Console or on the command line:

    gcloud container clusters create <my-cluster>

 2. Grab the credentials for kubernetes to connected

    gcloud container clusters get-credentials

 3. Login with application default creds for some weird reason:

     gcloud auth application-default login

 4. Should be good to go. Run `kubectl get events` or something to test.
 5. You might need to manually add the postgres disk to the cluster machine?

# Starting the Cluster

     kubectl apply -f core

     kubectl apply -f dilectic

     kubectl apply -f platform

     kubectl apply -f platform/import

# Alerting
To checkout the Prometheus/AlertManager UIs in the event of an outage:

 1. Find out the IP of one of the Kubernetes cluster boxes.
 2. Create ssh tunnels:

      ssh -fnNT -L 32220:localhost:32220 -L 32221:localhost:32221 <IP>
