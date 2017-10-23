local quarticService = import "../_jsonnet/utils/quartic-service.libsonnet";

function (config) quarticService + {
    config: config,

    name: "eval",
    namespace: "platform",
    port: 8210,

    resources: {
        requests: {
            cpu: "100m",
        },
    },

    dropwizardConfig: {
        registry_url: "http://registry:8190/api",
        catalogue_url: "http://catalogue:8090/api",
        howl_url: "http://howl:8120/api",
        hey_url: "http://hey/",
        home_url_format: "https://%s.{{cluster.gcloud.domain_name}}",

        qube: {
            url: "ws://qube:8202",
            pod: {
                containers: [
                    {
                        name: "quarty",
                        image: "%s/jupyter:%d" % [$.config.gcloud.docker_repository, $.config.jupyter.version],
                        command: [
                            "sudo",
                            "-E",
                            "-u",
                            "jovyan",
                            "bash",
                            "-c",
                            |||
                                set -eu
                                export PATH=/opt/conda/bin:$PATH
                                pip install --upgrade git+git://github.com/quartictech/quartic-python.git@%s
                                pip install http://qube.platform:8200/api/backchannel/runner
                                python -u -m quarty.server
                            ||| % [$.config.quartic_python_version],
                        ],
                        port: 8080,
                        env: {                        
                            MYSQL_ROOT_PASSWORD: "aiCh7Yie" # TODO: "This is clearly noob" - OC
                        },
                    },
                    {
                        name: "mysql",
                        image: "mysql",
                        port: 3306,
                        env: {
                            MYSQL_ROOT_PASSWORD: "aiCh7Yie",
                        },
                    },
                ],
            },
        },

        github: {
            app_id: $.config.github.app_id,
            api_root_url: "https://api.github.com", # TODO - make this a config default
            private_key_encrypted: $.config.github.private_key_encrypted,
        },

        database: {
            host_name: "postgres",
            database_name: "eval",
            user: "postgres",
            password: $.config.postgres.password_encrypted,
        },
    },
}
