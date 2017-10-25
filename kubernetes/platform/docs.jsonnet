local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.frontendService("docs", "platform", cluster)
