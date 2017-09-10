local quarticService = import "../utils/quartic-service.jsonnet";

quarticService + {
    name: "catalogue",
    namespace: "platform",
    port: 8090,

    dropwizardConfig: {
        backend: {
            type: "google_datastore",
            projectId: "quartictech",
            namespace: $.config.datastoreNamespacePrefix + "-catalogue"
        },
    },
}
