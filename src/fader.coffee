

{ EventEmitter } = require 'events'


class Fader extends EventEmitter
  value: 0

  constructor: (channel) ->
    @channel  = channel
    @position = [190, 16 + channel]

  updateValue: (value) ->
    @value = value
    @emit 'update', value


module.exports = Fader
