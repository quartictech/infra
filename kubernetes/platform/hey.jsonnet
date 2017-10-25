local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.backendService("hey", "platform", 80, cluster) {
    env: {
        DEV_MODE: "false",
        SLACK_TOKEN_ENCRYPTED: cluster.slack.token_encrypted,
        SLACK_USERNAME: cluster.slack.username,
        DEFAULT_SLACK_CHANNEL: cluster.slack.default_channel,
    },
}
