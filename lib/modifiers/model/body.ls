{set, act} = require \glad-functions

module.exports =
  add_date: (name, body)-->
    body
    |> act set name, (new Date)
