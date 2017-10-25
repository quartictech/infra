local k8s = import "./k8s.libsonnet";

{
    local defaultCpuRequest = "100m",

    local _container(name, imageName, imageTag, ports, cpuRequest, cluster) = k8s.container(
        name,
        "%s/%s:%s" % [cluster.gcloud.docker_repository, imageName, imageTag],
        [ p.port for p in ports ]
    ) {
        resources: {
            requests: {
                cpu: cpuRequest,
            },
        },
    },


    frontendService(name, namespace, cluster):: {
        local fs = self,
        imageName:: name,
        imageTag:: cluster.platform_version,
        cpuRequest:: defaultCpuRequest,

        local allPorts = [
            { port: 80, name: "default" },
        ],
        local service = k8s.service(name, namespace, allPorts),
        local deployment = k8s.deployment(name, namespace) {
            containers: [_container(name, fs.imageName, fs.imageTag, allPorts, fs.cpuRequest, cluster)],
        },

        apiVersion: "v1",
        kind: "List",
        items: [service, deployment],
    },


    backendService(name, namespace, port, cluster):: {
        local bs = self,
        imageName:: name,
        imageTag:: cluster.platform_version,
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

        local container = _container(name, bs.imageName, bs.imageTag, allPorts, bs.cpuRequest, cluster) {
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