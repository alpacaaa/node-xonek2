
{ EventEmitter } = require 'events'
Button = require './button'


class Knob extends EventEmitter
  value: 0
  button: null
  channel: null
  position: null

  constructor: (channel, knob) ->
    @channel  = channel
    @position = knobPosition channel, knob
    @button = new Button channel, knob

  updateValue: (value) ->
    @value = value
    @emit 'update', value



knobPosition = (channel, position) ->
  # (top left) -> 4
  value = channel + (4 * (position + 1))
  [190, value]


module.exports = Knob
