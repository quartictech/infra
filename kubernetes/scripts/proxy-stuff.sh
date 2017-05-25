#! /bin/bash
set -eu

namespace=${1}

function pod_name() {
    local service=${1}
    kubectl get pod -n ${namespace} -o name -lcomponent=${service} | awk -F/ '{print $2}'
}

function kill_pf() {
    local port=${1}
    ps -ef | grep port-forward | grep ${port} | awk '{print $2}' | xargs kill -9
}

kill_pf 8090
kill_pf 8120

kubectl port-forward -n ${namespace} `pod_name catalogue` 8090 &
kubectl port-forward -n ${namespace} `pod_name howl` 8120 &