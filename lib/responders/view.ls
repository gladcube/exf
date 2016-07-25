{let_} = require \glad-functions

# (Request, Response, Data, ActionType, ControllerName, Options)-> Response
module.exports = (req, res, data, action, name, {respond_with: extra}:options)->
  let_ res, \render, "#name/#action",
    (
      req: req
      data: data
      controller: name
      action: action
    ) |> merge extra req, res, data, action, name, options

