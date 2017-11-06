{
    list(items):: {
        # kubectl can't handle nested lists, so unpack and flatten
        local _maybeUnpackList(x) = if (x.kind == "List") then x.items else [x],

        apiVersion: "v1",
        kind: "List",
        items: std.flattenArrays(std.map(_maybeUnpackList, items)),
    },


    namespace(namespaceName):: {
        apiVersion: "v1",
        kind: "Namespace",
        metadata: {
            name: namespaceName,
            labels: {
                name: namespaceName,    # Our convention that allows network policies to select specific namespaces
            },
        },
    },


    ingress(name, namespace, domain):: {
        local me = self,
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
            tls: me.certs,
            rules: me.rules,
        },
    },


    deployment(name, namespace):: {
        local me = self,
        nodePool:: "core",
        containers:: [],
        volumes:: [],
        labels:: { component: name },

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
                    labels: me.labels,
                },
                spec: {
                    nodeSelector: {
                        "cloud.google.com/gke-nodepool": me.nodePool,
                    },
                    containers: me.containers,
                    volumes: me.volumes,
                },
            }
        }
    },


    # TODO - this is very similar to deployment, perhaps we can unify?
    statefulSet:: {
        new(name, namespace):: {
            local me = self,
            serviceName:: me.name,
            nodePool:: "core",
            containers:: [],
            volumeClaimTemplates:: [],
            labels:: { component: name },

            apiVersion: "apps/v1beta1",
            kind: "StatefulSet",
            metadata: {
                name: name,
                namespace: namespace,
            },
            spec: {
                serviceName: me.serviceName,
                replicas: 1,
                template: {
                    metadata: {
                        labels: me.labels,
                    },
                    spec: {
                        nodeSelector: {
                            "cloud.google.com/gke-nodepool": me.nodePool,
                        },
                        containers: me.containers,
                    },
                },
                volumeClaimTemplates: me.volumeClaimTemplates,
            },
        },


        mixin:: {
            volumeClaimTemplate(name, storageClass, size):: {
                volumeClaimTemplates+:: [{
                    metadata: {
                        name: name,
                        annotations: {
                            "volume.beta.kubernetes.io/storage-class": storageClass,
                        },
                    },
                    spec: {
                        accessModes: [ "ReadWriteOnce" ],
                        resources: {
                            requests: {
                                storage: size,
                            },
                        },
                    },
                }],
            },
        },
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
        local me = self,
        annotations:: {},

        apiVersion: "v1",
        kind: "Service",
        metadata: {
            name: name,
            namespace: namespace,
            labels: {
                component: name,
            },
            annotations: me.annotations,
        },
        spec: {
            ports: std.map(function (p) p { protocol: "TCP" }, ports),
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


    networkPolicy(name, namespace):: {
        apiVersion: "networking.k8s.io/v1",
        kind: "NetworkPolicy",
        metadata: {
            name: name,
            namespace: namespace,
        },
    },
}
