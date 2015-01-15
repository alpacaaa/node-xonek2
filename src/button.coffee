
Component = require './base-component'
Led = require './led'

class Button extends Component
  is_pressed: false

  constructor: (channel, button) ->
    @led = new Led channel, button
    position = @led.position[1]
    @position_pressed  = [158, position]
    @position_released = [142, position]

  updateValue: (value, msg) ->
    event = if value == 1 then 'press' else 'release'
    @is_pressed = event == 'press'
    @emit event, msg


module.exports = Button
