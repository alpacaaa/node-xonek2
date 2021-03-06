
Component = require './base-component'
Button = require './button'
Led = require './led'


class EndlessKnob extends Component

  led: null
  button: null

  constructor: (channel, options = {}) ->
    @channel  = channel
    @position = [190, channel]

    @button = new Button 0, 0
    button_position = options.button ? 52 + channel
    @button.position_pressed[1]  = button_position
    @button.position_released[1] = button_position

    @button.led = null # sucks big times

    return unless options.led
    @led = new Led 4 + channel, 0

  updateValue: (value, msg) ->
    ret = 1
    ret = -1 if value == 1
    @emit 'update', ret, msg


module.exports = EndlessKnob
