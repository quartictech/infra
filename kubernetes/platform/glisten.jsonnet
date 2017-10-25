local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.backendService("glisten", "platform", 8170, cluster) {
    dropwizardConfig: {
        eval_url: "http://eval:8210/api",
        webhook_secret_encrypted: cluster.github.webhook_secret_encrypted
    }
}
