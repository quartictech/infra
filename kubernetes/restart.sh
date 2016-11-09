kubectl --namespace dilectic apply -f dilectic
kubectl --namespace dilectic delete -f dilectic/dilectic-deployment.yml
kubectl --namespace dilectic create -f dilectic/dilectic-deployment.yml
kubectl --namespace dilectic get pods

