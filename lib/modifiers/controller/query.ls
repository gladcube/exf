{merge, $_pairs} = require \glad-functions

module.exports =
  set_filter_from_query: (keys, query)-->
    query
    |> merge (
      filter:
        query
        |> $_pairs filter (at 0) >> (in keys)
    )
