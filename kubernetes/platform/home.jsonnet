local k = import "../_jsonnet/k8s.libsonnet";
local q = import "../_jsonnet/quartic.libsonnet";

function (config) k.list([
    q.backendService("home", "platform", 8100, config) {
        dropwizardConfig: {
            catalogue_url: "http://catalogue:8090/api",
            howl_url: "http://howl:8120/api",
            registry_url: "http://registry:8190/api",
            eval_url: "http://eval:8210/api",

            github: {
                client_id: config.github.client_id,
                client_secret_encrypted: config.github.client_secret_encrypted,
                trampoline_url: "https://api.%s/api/auth/gh/callback" % [config.gcloud.domain_name],
                redirect_host: "https://%%s.%s" % [config.gcloud.domain_name],
                scopes: ["user"],
            },

            cookies: {
                secure: true,
                max_age_seconds: 30 * 24 * 3600,
                signing_key_encrypted_base64: config.token_signing_key_encrypted,
            },
        }
    },
    q.frontendService("home-frontend", "platform", config),
])
