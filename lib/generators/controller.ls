{C, let_} = require \glad-functions
{tableize} = require \inflection
json = C let_ _, \json, _

module.exports = (
  name,
  {
    find_all, find, persist,
    update, delete: delete_
  }:model,
  {path}:options?
)->
  name: name
  path: path ? (name |> tableize |> (\/ +))
  index: ({query}:req, res)-->
    err, data <- find_all query
    json data, res
  show: ({query}:req, res)-->
    err, data <- find query
    json data, res
  persist: ({body}:req, res)-->
    err, data <- persist body
    json data, res
  update: ({body}:req, res)-->
    err, data <- update body
    json data, res
  delete: ({body}:req, res)-->
    err, data <- delete_ body
    json data, res

