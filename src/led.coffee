


xonek2 = null


class Led
  is_on: false
  color: null

  constructor: (channel, position) ->
    initModule()
    @position = ledPosition channel, position

  turn_on: (color = xonek2.COLOR_RED) ->
    @is_on = true
    @color = color

    msg = @position.concat(127)
    msg[1] = led_color msg[1], color

    xonek2.midi.output.sendMessage msg

  turn_off: ->
    @is_on = false
    @color = null
    xonek2.midi.output.sendMessage @position.concat(0)





initModule = ->
  return if xonek2
  xonek2 = require './xonek2'



ledPosition = (channel, position) ->
  # C1 (bottom left) -> 24 (red)
  # C4 (bottom left) -> 60 (orange)
  # C7 (bottom left) -> 96 (green)

  value = 48 + channel - (position * 4)
  [158, value]


led_color = (value, color) ->
  orange = 36

  # motherfucking big buttons follow a different pattern
  if value in [12, 15]
    orange = 4

  green = orange * 2

  switch color
    when xonek2.COLOR_RED then value
    when xonek2.COLOR_ORANGE then value + orange
    when xonek2.COLOR_GREEN then value + green


module.exports = Led
