{get, $$, let_} = require \glad-functions

path = get \path

path_with_id = path >> (+ \/:id)

module.exports = (controller, app)-->
  let (
    route = (method, path, action)-->
      controller
      |> $$ [path, get action]
      |> when_ (at 1) >> (?), apply let_ app, method, _, _
  )
    [
      [\get, path, \index]
      [\get, path_with_id, \show]
      [\post, path, \persist]
      [\put, path_with_id, \update]
      [\delete, path_with_id, \delete]
    ] |> map apply route

