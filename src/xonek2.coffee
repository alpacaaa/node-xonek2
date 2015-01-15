

# Copyright (c) 2015, Marco Sampellegrini <babbonatale@alpacaaa.net>
#
#
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee
# is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
# FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.



midi = require 'midi'

Button  = require './button'
Channel = require './channel'
EndlessKnob = require './endless_knob'


targetPort = 'XONE:K2'

constants =
  COLOR_RED: 0
  COLOR_GREEN: 1
  COLOR_ORANGE: 2


midi_connection =
  input:  null
  output: null


class XONEK2

  # hash of all components on the controller
  components: {}

  # last strip of components
  # 2 big buttons + 2 endless knobs
  utils: {}

  is_connected: false


  constructor: ->
    @channels = [0..3].map (channel) ->
      new Channel channel

    @utils = @initUtils()
    @components = @initComponents()


  connect: ->
    @openMidiConnection()

    port = @findValidPort()
    return if port is false

    midi_connection.input.openPort port
    midi_connection.output.openPort port

    @initListener()
    @is_connected = true

  openMidiConnection: ->
    midi_connection.input  = new midi.input()
    midi_connection.output = new midi.output()

  findValidPort: ->
    input = midi_connection.input
    portsCount = input.getPortCount()

    while portsCount--
      current = input.getPortName portsCount
      return portsCount if current == main.port

    false


  initComponents: ->
    addButton = (acc, button) ->
      acc[button.position_pressed]  = button
      acc[button.position_released] = button

    ret = @channels.reduce ((acc, channel) ->
      channel.knobs.forEach (knob) ->
        button = knob.button
        acc[knob.position] = knob
        addButton acc, button

      fader = channel.fader
      acc[fader.position] = fader

      endless_knob = channel.endless_knob
      acc[endless_knob.position] = endless_knob
      addButton acc, endless_knob.button

      channel.buttons.forEach (button) ->
        addButton acc, button

      acc
    ), {}

    @utils.buttons.forEach (button) ->
      addButton ret, button

    @utils.endless_knobs.forEach (knob) ->
      button = knob.button
      ret[knob.position] = knob
      addButton ret, button

    ret


  initUtils: ->
    buttons: [
      # the LAYER button doesn't respond in a predictable manner
      # it probably has to do with its special functionalities
      # with latching layers and stuff
      new Button 0, 9
      new Button 3, 9
    ]
    endless_knobs: [
      new EndlessKnob 20, button: 13
      new EndlessKnob 21, button: 14
    ]

  initListener: ->
    input = midi_connection.input

    input.on 'message', (time, msg) =>
      position  = msg[0..1].toString()
      component = @components[position]
      return unless component

      value = msg[2] / 127
      component.updateValue value, msg

  reset_leds: ->
    output = midi_connection.output
    [0..127].forEach (index) ->
      output.sendMessage [158, index, 0]




main =
  create: -> new XONEK2
  midi: midi_connection
  port: targetPort

Object.keys(constants).forEach (item) ->
  main[item] = constants[item]


module.exports = main
