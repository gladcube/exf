{merge, $_arg} = require \glad-functions
{extend}:module_extender = require \module-extender

module.exports =
  module_extender
  |> merge (
    modify_body_before: (action, modifier, model)-->
      extend action, (
        $_arg 0, modifier
      ), model
  )

