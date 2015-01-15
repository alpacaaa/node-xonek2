
Button = require './button'
Component = require './base-component'


class Knob extends Component
  button: null
  channel: null
  position: null

  constructor: (channel, knob) ->
    @channel  = channel
    @position = knobPosition channel, knob
    @button = new Button channel, knob


knobPosition = (channel, position) ->
  # (top left) -> 4
  value = channel + (4 * (position + 1))
  [190, value]


module.exports = Knob
