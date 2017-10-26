local k = import "../_jsonnet/k8s.libsonnet";

function (config) k.ingress("ingress", "platform", config.gcloud.domain_name) {
    local subdomains = std.map(function(c) c.registry.subdomain, config.customers),

    certs: [
        $.cert("api"),
        $.cert("docs"),
    ] + std.map(function (d) $.cert(d), subdomains),

    rules: [
        $.rule("api", [
            $.path("/api/auth/gh/callback",  "home",            8100),
            $.path("/api/hooks/github",      "glisten",         8170),
        ]),
        $.rule("docs", [
            $.path("/",                      "docs",            80),
        ]),
    ] + std.map(
        function (d) $.rule(d, [
            $.path("/",                      "home-frontend",   80),
            $.path("/api",                   "home",            8100),
        ]),
        subdomains
    ),
}
