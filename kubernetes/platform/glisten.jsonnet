local quarticService = import "../_jsonnet/utils/quartic-service.libsonnet";

function (config) quarticService + {
    config: config,

    name: "glisten",
    namespace: "platform",
    port: 8170,

    dropwizardConfig: {
        eval_url: "http://eval:8210/api",
        webhook_secret_encrypted: $.config.github.webhook_secret_encrypted
    }
}
