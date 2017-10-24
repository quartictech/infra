local utils = import "../_jsonnet/utils/utils.libsonnet";

local sudomains(customers) = std.map(function(c) c.registry.subdomain, customers);

function (config) utils.ingress + {
    name: "ingress",
    namespace: "platform",
    domain: config.gcloud.domain_name,

    certs: [
        $.cert("api"),
        $.cert("docs"),
    ] + std.map(function (d) $.cert(d), sudomains(config.customers)),

    rules: [
        $.rule("api", [
            $.path("/api/auth/gh/callback",  "home",     8100),
            $.path("/api/hooks/github",      "glisten",  8170),
        ]),
        $.rule("docs", [
            $.path("/",                      "docs",     80),
        ]),
    ] + std.map(
        function (d) $.rule(d, [
            $.path("/",                      "home",     80),
            $.path("/api",                   "home",     8100),
        ]),
        sudomains(config.customers)
    ),
}
