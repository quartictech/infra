local k = import "../_jsonnet/k8s.libsonnet";
local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) k.list([
    q.backendService("home", "platform", 8100, cluster) {
        dropwizardConfig: {
            catalogue_url: "http://catalogue:8090/api",
            howl_url: "http://howl:8120/api",
            registry_url: "http://registry:8190/api",
            eval_url: "http://eval:8210/api",

            github: {
                client_id: cluster.github.client_id,
                client_secret_encrypted: cluster.github.client_secret_encrypted,
                trampoline_url: "https://api.%s/api/auth/gh/callback" % [cluster.gcloud.domain_name],
                redirect_host: "https://%%s.%s" % [cluster.gcloud.domain_name],
                scopes: ["user"],
            },

            cookies: {
                secure: true,
                max_age_seconds: 30 * 24 * 3600,
            },

            auth: {
                type: "token",
                key_encrypted_base64: cluster.token_signing_key_encrypted,
            },
        }
    },
    q.frontendService("home-frontend", "platform", cluster),
])
