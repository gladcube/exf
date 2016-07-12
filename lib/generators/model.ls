module.exports = (name)->
  name: name
  find_all: (options, cb)->
    cb undefined, []
  find: (options, cb)-> do cb
  persist: (body, cb)-> do cb
  update: (body, cb)-> do cb
  delete: (body, cb)-> do cb


