{act, $$, delete_, merge} = require \glad-functions
{apply: apply_schema} = require \schemaf

module.exports =
  set_filter_from_query: (schema, query)-->
    query
    |> merge (
      filter: apply_schema schema, query
    )
    |> act $$ (map delete_, (keys schema))

