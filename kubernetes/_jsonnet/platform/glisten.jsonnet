local quarticService = import "../utils/quartic-service.jsonnet";

quarticService + {
    name: "glisten",
    namespace: "platform",
    port: 8170,

    dropwizardConfig: {
        evalUrl: "http://eval:8210/api",
        webhookSecretEncrypted: $.config.github.webhookSecret
    }
}
