local config = import "../config/clusters/prod.jsonnet";
local quarticService = import "../_jsonnet/utils/quartic-service.jsonnet";

quarticService + {
    config: config,

    name: "catalogue",
    namespace: "platform",
    port: 8090,

    dropwizardConfig: {
        backend: {
            type: "google_datastore",
            projectId: "quartictech",
            namespace: $.config.datastore_namespace_prefix + "-catalogue"
        },
    },
}
