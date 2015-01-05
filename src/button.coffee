
{ EventEmitter } = require 'events'
Led = require './led'

class Button extends EventEmitter
  is_pressed: false

  constructor: (channel, button) ->
    @led = new Led channel, button
    position = @led.position[1]
    @position_pressed  = [158, position]
    @position_released = [142, position]

  updateValue: (value) ->
    event = if value == 127 then 'press' else 'release'
    @is_pressed = event == 'press'
    @emit event


module.exports = Button
