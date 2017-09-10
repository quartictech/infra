local utils = import "../utils/utils.jsonnet";

{
    apiVersion: "v1",
    kind: "List",
    items: utils.collect([
        import "catalogue.jsonnet",
        import "glisten.jsonnet",
    ]),
}