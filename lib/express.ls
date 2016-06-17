{call} = require \glad-functions

module.exports =
  # ... -> ExpressApp -> Any
  listen: call \listen, _, _
  set: call \set, _, _, _
  use: call \use, _, _
  use_in: call \use, _, _, _
  get: call \get, _, _, _
  post: call \post, _, _, _
  put: call \put, _, _, _
  delete: call \delete, _, _, _
  route: call \route, _, _

  # Any -> ExpressResponse -> Any
  render: call \render, _, _
  end: call \end, _, _
  json: call \json, _, _

