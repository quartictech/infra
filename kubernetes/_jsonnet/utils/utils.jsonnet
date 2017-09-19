{
    collect(services):: (
        std.flattenArrays(
            std.map(
                function (s) s.items,
                services
            )
        )
    )
}