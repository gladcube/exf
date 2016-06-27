## Overview

### Introduction
"exf" provides a collection of helper modules that help defining Models and Controllers on Express framework.

"exf" consists of three types of modules, "generators", "controllers" and "modifiers".

In addition to these, "express" & "restfulize" provides collection of functional wrapper for basic Express modules.

#### generators
"generators" generates Model or controller from specific name, base module that like   Model(at controller) or db connection and schema definitions(at Model), and options.

Even without options, it generates module that has basic methods though, with options, you can extend or modify that.

options are defined with "extenders" or "modifiers".

#### extenders
"extenders" extends methods that are defined in generators.
If you need some special process before/after the basic methods, you can use this.

#### modifiers
"modifiers" extends methods that are defined in generators.
If you need to modify the basic methods, you can use this.

### Generator module List

||Model|Controller|
|---|---|---|
|generators|Generates Model from db connection definitions |Generates Controller from specific Model module|
|extenders|Extends basic methods of generated Model|Extends basic methods of generated Controller|
|modifiers|Modifies basic methods of generated Model|Modifies basic methods of generated Controller|

## Usage
#### Controller Generator

To define the common controller generator may be good.
```livescript
{
  generators: {controller: generate}
  extenders: {controller: {modify_query_before}}
  modifiers: {controller: {query: {set_filter_from_query}}}
  } = require \exf

  module.exports = (name, {queries_to_filter}:options?)->
  generate name, (require "../models/#name.ls"), options
  |> if_ queries_to_filter?,
  modify_query_before \index, set_filter_from_query queries_to_filter
```

A specific controller is defined by to call the common generator (simple controller)
```livescript
generate = require \../services/app-controller-generator.ls

module.exports =
  generate \product
```

A specific controller is defined by to calls the common generator (with extender)
```livescript
generate = require \../services/app-model-generator.ls
...
{find} = module.exports =
  generate \layout, schema
  #extend basic method
  |> before \update, (body, cb, next)->
    ...
  #add the specific methods
  |> merge (
    get_states: get_states = (layout, cb)-->
      ...
    get_fleet_units: get_fleet_units = (layout, cb)-->
      ...
    ...
    )
```


#### Model generator

To define the common model generator may be good.
```livescript
{
  generators: {"mongo-model": generate}
  modifiers: {model: {body: {add_date}}}
  extenders: {model: {modify_body_before}}
} = require \exf
{apply: apply_schema} = require \schemaf
host = env \MONGODB_HOST
port = env \MONGODB_PORT
db = env \MONGODB_DB

module.exports = (name, schema, options)->
  generate name, host, port, db, options
  |> modify_body_before \persist,
    (add_date \created_date)
    >> (add_date \updated_date)
    >> (apply_schema schema)
  |> modify_body_before \update,
    (add_date \updated_date)
    >> (apply_schema schema)
  |> modify_body_before \delete,
    (apply_schema schema)
```

A specific controller is defined by to calls the common generator.
```livescript
generate = require \../services/app-model-generator.ls
...

module.exports =
  generate \product, (
    _id: mongo_object_id
    name: string
    created_date: date
    updated_date: date
  )
```

A specific controller is defined by to calls the common generator(with extender).
```livescript
generate = require \../services/app-model-generator.ls
...
{find} = module.exports =
  generate \layout, schema
  |> before \update, (body, cb, next)->
    ...
  |> merge (
    get_states: get_states = (layout, cb)-->
      ...
    get_fleet_units: get_fleet_units = (layout, cb)-->
      ...
```


#### express & restfulize

"express" provides functional style wrapper of Express modules.
"restfulize" provides the interface of controller that follows REST architecture style.

```livescript
{static: static_}:express = require \express
{
  restfulize,
  express: {
    listen, set: _set, get: _get,
    use, use_in, render, end
  }
} = require \exf
...
configure =
  act $$ [
    listen port
    _set \views, "#__dirname/../../views"
...
  ]
serve =
  express
  >> configure
  >> ($$ map restfulize, controllers)
  >> (lazy console~info, "Server is ready.")
```
