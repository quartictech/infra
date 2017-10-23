{
    config:: error "config must be specified",

    name:: error "name must be specified",
    namespace:: error "namespace must be specified",
    version:: error "version must be specified",
    port:: error "port must be specified",
    dropwizardConfig:: {},

    local configMap = {
        apiVersion: "v1",
        kind: "ConfigMap",
        metadata: {
            name: $.name,
            namespace: $.namespace,
        },
        data: {
            "config.yml": std.manifestJson($.dropwizardConfig + {
                url: {
                    port: $.port,
                },
            }),
        },
    },

    local service = {
        apiVersion: "v1",
        kind: "Service",
        metadata: {
            name: $.name,
            namespace: $.namespace,
            labels: {
                component: $.name,
            },
            annotations: {
                "quartic.io/healthcheck_path": "/healthcheck",
                "quartic.io/healthcheck_port": std.toString($.port + 1),
            },
        },
        spec: {
            ports: [
                {
                    port: $.port,
                    protocol: "TCP",
                    name: "default",
                },
                {
                    port: $.port + 1,
                    protocol: "TCP",
                    name: "admin",
                }
            ],
            selector: {
                component: $.name,
            },
        }
    },

    local container = {
        name: $.name,
        image: "%s/%s:%d" % [$.config.gcloud.docker_repository, $.name, $.config.platform_version],
        ports: [
            { containerPort: $.port },
            { containerPort: $.port + 1 },
        ],
        env: [
            {
                name: "MASTER_KEY_BASE64",
                valueFrom: {
                    secretKeyRef: {
                        name: "secrets",
                        key: "master_key_base64",
                    },
                }
            },
        ],
        volumeMounts: [
            {
                name: "config",
                mountPath: "/service/config.yml",
                subPath: "config.yml",
            },
        ],
        resources: $.resources,
    },

    local deployment = {
        apiVersion: "extensions/v1beta1",
        kind: "Deployment",
        metadata: {
            name: $.name,
            namespace: $.namespace,
        },
        spec: {
            replicas: 1,
            template: {
                metadata: {
                    labels: {
                        component: $.name,
                    },
                },
                spec: {
                    nodeSelector: {
                        "cloud.google.com/gke-nodepool": "core",
                    },
                    containers: [container],
                    volumes: [
                        {
                            name: "config",
                            configMap: {
                                name: $.name,
                            },
                        },
                    ],
                },
            }
        }
    },

    apiVersion: "v1",
    kind: "List",
    items: [configMap, service, deployment],
}