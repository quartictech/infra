{
    list(items):: {
        local _maybeUnpackList(x) = if (x.kind == "List") then x.items else [x],

        apiVersion: "v1",
        kind: "List",
        items: std.flattenArrays(std.map(_maybeUnpackList, items)),
    },


    ingress(name, namespace, domain):: {
        local ing = self,
        certs:: [],
        rules:: [],

        cert(host):: {
            secretName: "tls-%s-%s" % [namespace, host],
            hosts: ["%s.%s" % [host, domain]],
        },

        rule(host, httpPaths):: {
            host: "%s.%s" % [host, domain],
            http: {
                paths: httpPaths,
            },
        },

        path(path, backendServiceName, backendPort):: {
            path: path,
            backend: {
                serviceName: backendServiceName,
                servicePort: backendPort,
            },
        },

        apiVersion: "extensions/v1beta1",
        kind: "Ingress",
        metadata: {
            name: name,
            namespace: namespace,
            annotations: {
                "kubernetes.io/ingress.class": "nginx",
                "kubernetes.io/tls-acme": "true",
            },
        },
        spec: {
            tls: ing.certs,
            rules: ing.rules,
        },
    },


    deployment(name, namespace):: {
        local deploy = self,
        nodePool:: "core",
        containers:: [],
        volumes:: [],

        apiVersion: "extensions/v1beta1",
        kind: "Deployment",
        metadata: {
            name: name,
            namespace: namespace,
        },
        spec: {
            replicas: 1,
            template: {
                metadata: {
                    labels: {
                        component: name,
                    },
                },
                spec: {
                    nodeSelector: {
                        "cloud.google.com/gke-nodepool": deploy.nodePool,
                    },
                    containers: deploy.containers,
                    volumes: deploy.volumes,
                },
            }
        }
    },


    container(name, image, ports):: {
        envVarFromSecret(varName, secretName, secretKey):: {
            name: varName,
            valueFrom: {
                secretKeyRef: {
                    name: secretName,
                    key: secretKey,
                },
            }
        },

        name: name,
        image: image,
        ports: std.map(function (p) { containerPort: p }, ports),
        env: [],
        volumeMounts: [],
        resources: {},
    },


    service(name, namespace, ports):: {
        local svc = self,
        annotations:: {},

        apiVersion: "v1",
        kind: "Service",
        metadata: {
            name: name,
            namespace: namespace,
            labels: {
                component: name,
            },
            annotations: svc.annotations,
        },
        spec: {
            ports: std.map(function (p) p + { protocol: "TCP" }, ports),
            selector: {
                component: name,
            },
        }
    },

    
    configMap(name, namespace):: {
        apiVersion: "v1",
        kind: "ConfigMap",
        metadata: {
            name: name,
            namespace: namespace,
        },
    },
}