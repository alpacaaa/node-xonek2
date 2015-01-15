
{ EventEmitter } = require 'events'

class Component extends EventEmitter
  value: 0

  updateValue: (value, msg) ->
    @value = value
    @emit 'update', value, msg


module.exports = Component
