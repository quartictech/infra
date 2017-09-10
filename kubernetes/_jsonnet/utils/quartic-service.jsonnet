{
    name:: error "name must be specified",
    namespace:: error "namespace must be specified",
    version:: error "version must be specified",
    port:: error "port must be specified",
    dropwizardConfig:: {},
    javaOpts:: [],

    config:: import "../config.jsonnet",

    local configMap = {
        apiVersion: "v1",
        kind: "ConfigMap",
        metadata: {
            name: $.name + "-config",
            namespace: $.namespace
        },
        data: {
            "config.yml": std.manifestJson($.dropwizardConfig + {
                url: {
                    port: $.port
                },
            })
        },
    },

    local service = {
        apiVersion: "v1",
        kind: "Service",
        metadata: {
            name: $.name,
            namespace: $.namespace
        },
        labels: {
            component: $.name
        },
        annotations: {
            "quartic.io/healthcheck_path": "/healthcheck",
            "quartic.io/healthcheck_port": $.port + 1,
        },
        spec: {
            ports: [
                {
                    port: $.port,
                    protocol: "TCP",
                    name: "default"
                },
                {
                    port: $.port + 1,
                    protocol: "TCP",
                    name: "admin"
                }
            ],
            selector: {
                component: $.name
            }
        }
    },

    local container = {
        name: $.name,
        image: "eu.gcr.io/quartictech/" + $.name + ":" + $.config.platformVersion,
        ports: [
            { containerPort: $.port },
            { containerPort: $.port + 1 }
        ],
        env: [
            {
                name: "MASTER_KEY_BASE64",
                valueFrom: {
                    secretKeyRef: {
                        name: "secrets",
                        key: "master_key_base64"
                    },
                }
            },
            {
                name: "JAVA_OPTS",
                value: std.join(" ", $.javaOpts)
            },
        ],
        resources: {
            requests: {
                cpu: "100m"
            },
        },
    },

    local deployment = {
        apiVersion: "extensions/v1beta1",
        kind: "Deployment",
        metadata: {
            name: $.name,
            namespace: $.namespace
        },
        spec: {
            replicas: 1,
            template: {
                metadata: {
                    labels: {
                        component: $.name
                    },
                },
                spec: {
                    containers: [container]
                },
            }
        }
    },

    apiVersion: "v1",
    kind: "List",
    items: [configMap, service, deployment]
}