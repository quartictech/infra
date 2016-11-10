kubectl --namespace dilectic apply -f dilectic
kubectl --namespace dilectic delete -f dilectic/dilectic.yml
kubectl --namespace dilectic create -f dilectic/dilectic.yml
kubectl --namespace dilectic get pods

