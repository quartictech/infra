local k = import "../_jsonnet/k8s.libsonnet";


local container(config) =
    k.container(name = "postgres", image = "postgres:%s" % [config.postgres.version], ports = [5432]) {
        env: [
            { name: "POSTGRES_PASSWORD", value: config.postgres.password_plaintext },
            { name: "PGDATA", value: "/var/lib/postgresql/data/pgdata" },
        ],
        volumeMounts: [
            { name: "postgres96-data", mountPath: "/var/lib/postgresql/data" },
        ],
        resources: {
            limits: {
                memory: "4Gi",
            },
        },
    };


local statefulSet(config) =
    k.statefulSet.new(name = "postgres96", namespace = "platform") {
        serviceName: "postgres",
        containers: [container(config)],
    } +
    k.statefulSet.mixin.volumeClaimTemplate(name = "postgres96-data", storageClass = "ssd", size = "100Gi");


local service = k.service(
    name = "postgres",
    namespace = "platform",
    ports = [{ protocol: "TCP", name: "default", port: 5432 }]
);


function (config) k.list([service, statefulSet(config)])
