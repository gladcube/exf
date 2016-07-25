{let_, args, pick} = require \glad-functions

# (Request, Response, Data, ActionType, ControllerName, Options)-> Response
module.exports =
  args
  >> (pick [1, 2])
  >> apply let_ _, \json, _

