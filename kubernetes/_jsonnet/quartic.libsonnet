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

    mixin:: {
        deploymentLabel(key, value):: { deploymentLabels+:: { [key]: value }, },
        requiresIngress:: $.mixin.deploymentLabel("requires-ingress", "true"),
        apiTrust(level):: $.mixin.deploymentLabel("api-trust", level),
    },


    frontendService(name, namespace, config):: {
        local me = self,
        image:: name,
        deploymentLabels:: {},
        cpuRequest:: defaultCpuRequest,

        local allPorts = [
            { port: 80, name: "default" },
        ],
        local service = k8s.service(name, namespace, allPorts),
        local deployment = k8s.deployment(name, namespace) {
            containers: [_container(name, me.image, allPorts, me.cpuRequest, config)],
        } + { labels+:: me.deploymentLabels },

        apiVersion: "v1",
        kind: "List",
        items: [service, deployment],
    },


    backendService(name, namespace, port, config):: {
        local me = self,
        image:: name,
        extraPorts:: [],
        dropwizardConfig:: {},
        deploymentLabels:: {},
        cpuRequest:: defaultCpuRequest,
        env:: {},

        local allPorts = bs.extraPorts + [
            { port: port,     name: "default" },
            { port: port + 1, name: "admin" },
        ],

        local configMap = k8s.configMap(name, namespace) {
            data: {
                "config.yml": std.manifestJson(me.dropwizardConfig {
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

        local container = _container(name, me.image, allPorts, me.cpuRequest, config) {
            env:
                [ self.envVarFromSecret("MASTER_KEY_BASE64", "secrets", "master_key_base64") ] +
                [ { name: "DEV_MODE", value: std.toString(config.dev_cluster) } ] +
                [ { name: k, value: bs.env[k] } for k in std.objectFields(me.env) ],
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
        } + { labels+:: me.deploymentLabels },

        apiVersion: "v1",
        kind: "List",
        items: [configMap, service, deployment],
    },
}