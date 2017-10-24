local k8s = import "./k8s.libsonnet";

{
    local defaultCpuRequest = "100m",

    local _container(name, image, ports, cpuRequest, config) = k8s.container(
        name,
        "%s/%s:%d" % [config.gcloud.docker_repository, image, config.platform_version],
        [ p.port for p in ports ]
    ) {
        resources: {
            requests: {
                cpu: cpuRequest,
            },
        },
    },


    frontendService(name, namespace, config):: {
        local fs = self,
        image:: name,
        cpuRequest:: defaultCpuRequest,

        local allPorts = [
            { port: 80, name: "default" },
        ],
        local service = k8s.service(name, namespace, allPorts),
        local deployment = k8s.deployment(name, namespace) {
            containers: [_container(name, fs.image, allPorts, fs.cpuRequest, config)],
        },

        apiVersion: "v1",
        kind: "List",
        items: [service, deployment],
    },


    backendService(name, namespace, port, config):: {
        local bs = self,
        image:: name,
        extraPorts:: [],
        dropwizardConfig:: {},
        cpuRequest:: defaultCpuRequest,
        env:: {},

        local allPorts = bs.extraPorts + [
            { port: port,     name: "default" },
            { port: port + 1, name: "admin" },
        ],

        local configMap = k8s.configMap(name, namespace) {
            data: {
                "config.yml": std.manifestJson(bs.dropwizardConfig {
                    url: {
                        port: port,
                    },
                }),
            },
        },

        local service = k8s.service(name, namespace, allPorts) {
            annotations: {
                "quartic.io/healthcheck_path": "/healthcheck",
                "quartic.io/healthcheck_port": std.toString(port + 1),
            },
        },

        local container = _container(name, bs.image, allPorts, bs.cpuRequest, config) {
            env:
                [ self.envVarFromSecret("MASTER_KEY_BASE64", "secrets", "master_key_base64") ] +
                [ { name: k, value: bs.env[k] } for k in std.objectFields(bs.env) ],
            volumeMounts: [
                {
                    name: "config",
                    mountPath: "/service/config.yml",
                    subPath: "config.yml",
                },
            ],
        },

        local deployment = k8s.deployment(name, namespace) {
            containers: [container],
            volumes: [
                {
                    name: "config",
                    configMap: {
                        name: name,
                    },
                },
            ],
        },

        apiVersion: "v1",
        kind: "List",
        items: [configMap, service, deployment],
    },
}