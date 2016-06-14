{merge, $_arg, set_$} = require \glad-functions
{extend}:module_extender = require \module-extender

module.exports =
  module_extender
  |> merge (
    modify_request_before: (action, modifier, model)-->
      extend action, (
        $_arg 0, modifier
      ), model
    modify_query_before: (action, modifier, model)-->
      extend action, (
        $_arg 0, (act set_$ \query, modifier)
      ), model
    modify_body_before: (action, modifier, model)-->
      extend action, (
        $_arg 0, (act set_$ \body, modifier)
      ), model
  )

