local q = import "../_jsonnet/quartic.libsonnet";

function (config)
    q.backendService("glisten", "platform", 8170, config) {
        dropwizardConfig: {
            eval_url: "http://eval:8210/api",
            webhook_secret_encrypted: config.github.webhook_secret_encrypted
        }
    } +
    q.mixin.requiresIngress

