

Knob = require './knob'
Fader = require './fader'
Button = require './button'
EndlessKnob = require './endless_knob'

class Channel
  knobs: []
  fader: null
  index: null
  buttons: []
  endless_knob: null

  constructor: (channel) ->
    @index = channel
    @knobs = [0..2].map (knob) -> new Knob channel, knob
    @fader = new Fader channel
    @buttons = [3..6].map (button) -> new Button channel, button
    @endless_knob = new EndlessKnob channel, led: true


module.exports = Channel
