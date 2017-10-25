local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.frontendService("www", "www", cluster) {
    imageName: "website",
    # CI is deploying latest via specific version tag, but if we ever reprovision then just grab latest as a fallback
    imageTag: cluster.www.default_website_tag,
}
