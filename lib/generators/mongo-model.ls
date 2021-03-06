{delete_, set, lazy, get, let_, args, $_at, return_} = require \glad-functions
{tableize} = require \inflection
{MongoClient: {connect}} = require \mongodb
slave_ok = process.env.SLAVE_OK or \no
conditions = {}

module.exports = (name, host, port, db, {collection_name}:options?)->
  states =
    connection: null
  set_connection = set \connection, _, states
  connection = lazy get, \connection, states
  if slave_ok is \yes then conditions <<< {readPreference:'secondaryPreferred'}
  collection = let_ _, \collection, (collection_name ? (name |> tableize)), conditions
  get_stats = (cb)->
    if connection!? => let_ that, \stats, cb
    else cb!
  get_connection = (cb)->
    err, stats <- get_stats
    if err?
      set_connection null
      |> lazy console~warn, \ConnectionClosed
    if connection!? then cb null, that; return
    err, res <- connect "mongodb://#host:#port/#{db}"
    set_connection res
    |> lazy get_connection, cb

  name: name
  find_all: ({filter}:options, cb)->
    if &0 |> is-type \Function => cb = options; options = {}
    err, db <- get_connection
    collection db
    |> let_ _, \find, filter, (options |> act delete_ \filter)
    |> let_ _, \toArray, cb
  count_all: ({filter}:options, cb)->
    if &0 |> is-type \Function => cb = options; options = {}
    err, db <- get_connection
    collection db
    |> let_ _, \count, filter, cb
  find: ({filter}:options, cb)->
    if &0 |> is-type \Function => cb = options; options = {}
    err, db <- get_connection
    collection db
    |> let_ _, \findOne, filter, cb
  persist: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \insertOne, body,
      args
      >> (except (at 1) >> (?), (++ {}))
      >> ($_at 1,
        (get \insertedId)
        >> (set \_id, _, body)
        >> (return_ body)
      )
      >> apply cb
  persist_many: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \insertMany, body, cb
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
  delete_many: (body, cb)->
    err, db <- get_connection
    let_ (collection db), \deleteMany, body,
      args
      >> ($_at 1, return_ body)
      >> apply cb


