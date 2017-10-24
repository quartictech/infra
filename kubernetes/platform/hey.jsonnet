local q = import "../_jsonnet/quartic.libsonnet";

function (config) q.backendService("hey", "platform", 80, config) + {
    env: {
        DEV_MODE: "false",
        SLACK_TOKEN_ENCRYPTED: config.slack.token_encrypted,
        SLACK_USERNAME: config.slack.username,
        DEFAULT_SLACK_CHANNEL: config.slack.default_channel,
    },
}
