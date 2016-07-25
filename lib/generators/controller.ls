{tableize} = require \inflection

# (Name, Model, Options?)-> Controller
module.exports = (
  name,
  {
    find_all, find, persist,
    update, delete: delete_
  }:model,
  {
    path,
    response_type = \json
  }:options = {}
)->
  respond ?= (require "../responders/#response_type.ls") _, _, _, _, name, options

  name: name
  path: path ? (name |> tableize |> (\/ +))
  index: ({query}:req, res)-->
    err, data <- find_all query
    respond req, res, data, \index
  show: ({query}:req, res)-->
    err, data <- find query
    respond req, res, data, \show
  persist: ({body}:req, res)-->
    err, data <- persist body
    respond req, res, data, \persist
  update: ({body}:req, res)-->
    err, data <- update body
    respond req, res, data, \update
  delete: ({body}:req, res)-->
    err, data <- delete_ body
    respond req, res, data, \delete

