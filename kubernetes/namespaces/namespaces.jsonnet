local k = import "../_jsonnet/k8s.libsonnet";

k.list([
    k.namespace("analysis"),
    k.namespace("backups"),
    k.namespace("core"),
    k.namespace("fringe"),
    k.namespace("platform"),
    k.namespace("sandbox"),
    k.namespace("www"),
])
