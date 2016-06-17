{call} = require \glad-functions

module.exports =
  # ExpressApp -> ...
  listen: call \listen, _, _
  set: call \set, _, _, _
  use: call \use, _, _
  get: call \get, _, _, _
  post: call \post, _, _, _
  put: call \put, _, _, _
  delete: call \delete, _, _, _

  # ExpressResponse -> ...
  render: call \render, _, _
  end: call \render, _, _
  json: call \json, _, _
