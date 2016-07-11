{set, lazy, get, let_, args, $_at, return_} = require \glad-functions
{tableize} = require \inflection
{MongoClient: {connect}} = require \mongodb

module.exports = (name, host, port, db, {collection_name}:options?)->
  states =
    connection: null
  set_connection = set \connection, _, states
  connection = lazy get, \connection, states
  collection = let_ _, \collection, (collection_name ? (name |> tableize))
  get_stats = (cb)->
    if connection!? => let_ that, \stats, cb
    else cb!
  get_connection = (cb)->
    err, stats <- get_stats
    if err?
      set_connection null
      |> lazy console~warn, \ConnectionClosed
    if connection!? then cb null, that; return
    err, res <- connect "mongodb://#host:#port/#db"
    set_connection res
    |> lazy get_connection, cb

  name: name
  find_all: ({filter}:options, cb)->
    err, db <- get_connection
    collection db
    |> let_ _, \find, filter
    |> let_ _, \toArray, cb
  find: ({filter}:options, cb)->
    err, db <- get_connection
    collection db
    |> let_ _, \findOne, filter, cb
  persist: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \insertOne, body,
      args
      >> ($_at 1, get \insertedId)
      >> ($_at 1, set \_id, _, body)
      >> ($_at 1, return_ body)
      >> apply cb
  persist_many: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \insertMany, body,
      args >> apply cb == cb
  update: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \updateOne,
      (_id: get \_id, body),
      ($set: body),
      args
      >> ($_at 1, return_ body)
      >> apply cb
  delete: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \deleteOne,
      (_id: get \_id, body),
      args
      >> ($_at 1, return_ body)
      >> apply cb
