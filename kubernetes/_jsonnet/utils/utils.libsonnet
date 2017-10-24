{
    collect(services):: (
        std.flattenArrays(
            std.map(
                function (s) s.items,
                services
            )
        )
    ),

    ingress:: {
        name:: error "name must be specified",
        namespace:: error "namespace must be specified",
        domain:: error "domain must be specified",
        certs:: [],
        rules:: [],

        local ing = self,

        cert(host):: {
            secretName: "tls-%s-%s" % [ing.namespace, host],
            hosts: ["%s.%s" % [host, ing.domain]],
        },

        rule(host, httpPaths):: {
            host: "%s.%s" % [host, ing.domain],
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
            name: ing.name,
            namespace: ing.namespace,
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
}