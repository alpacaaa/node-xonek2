# --compilers coffee:coffee-script/register

assert = require 'assert'
midi = require 'midi'

xonek2 = require '../src/xonek2'



emitEventTest = (component, output, msg, done) ->
  component.on 'update', (check) ->
    assert.equal msg[2], check
    done()

  output.sendMessage msg


ledTest = (input, expect, done) ->
  good = 0

  input.on 'message', (time, msg) ->
    ret = expect.filter (item) ->
      msg.toString() == item.toString()

    unless ret.length
      assert.fail msg, expect, 'Wrong midi msg received'

    done() if ++good == expect.length



describe 'XONE:K2 api', ->

  input  = null
  output = null
  controller = null

  before ->
    xonek2.port = 'XONE:K2--testing'
    input  = new midi.input()
    output = new midi.output()

    input.openVirtualPort  xonek2.port
    output.openVirtualPort xonek2.port

    controller = xonek2.create()


  afterEach ->
    input.removeAllListeners 'message'


  describe 'Module setup', ->

    it 'should bind to the correct port', ->
      assert.ok controller.connect(), "Can't connect to controller"
      assert.ok controller.is_connected


  describe 'Controller layout', ->

    it 'should have 4 channels', ->
      assert.equal 4, controller.channels.length

    it 'should have the correct number of components', ->
      channel = controller.channels[2]

      assert.ok channel.endless_knob
      assert.ok channel.fader
      assert.equal 3, channel.knobs.length
      assert.equal 4, channel.buttons.length

      utils = controller.utils
      assert.equal 2, utils.buttons.length
      assert.equal 2, utils.endless_knobs.length


  describe 'Controller events', ->

    it 'emits events for knobs', (done) ->
      knob  = controller.channels[3].knobs[1]
      emitEventTest knob, output, [190, 11, 60], done

    it 'emits events for fader', (done) ->
      fader = controller.channels[0].fader
      emitEventTest fader, output, [190, 16, 20], done

    it 'emits events for endless knob (turn right)', (done) ->
      knob = controller.channels[1].endless_knob
      emitEventTest knob, output, [190, 1, 1], done

    it 'emits events for endless knob (turn left)', (done) ->
      knob = controller.channels[3].endless_knob
      knob.on 'update', (check) ->
        assert.equal -1, check
        done()

      output.sendMessage [190, 3, 127]

    it 'emits events for buttons', (done) ->
      button  = controller.channels[2].buttons[1]
      pressed = false

      button.on 'press', -> pressed = true
      button.on 'release', ->
        assert.ok pressed, 'Press event not triggered'
        done()

      output.sendMessage [158, 34, 127]
      setTimeout (->
        output.sendMessage [142, 34, 0] # release
      ), 500



  describe 'Leds light up correctly', ->

    it 'turns on any led', (done) ->

      expect = [
        [158, 55, 127]
        [158, 41, 127]
        [158, 34, 127]
        [158, 15, 127]
      ]

      ledTest input, expect, done

      controller.channels[3].endless_knob.led.turn_on()
      controller.channels[1].knobs[2].button.led.turn_on()
      controller.channels[2].buttons[1].led.turn_on()
      controller.utils.buttons[1].led.turn_on()


    it 'turns on leds in different colors', (done) ->

      expect = [
        [158, 112, 127]
        [158, 63, 127]
      ]

      ledTest input, expect, done

      controller.channels[0].knobs[2].button.led.turn_on xonek2.COLOR_GREEN
      controller.channels[3].buttons[3].led.turn_on xonek2.COLOR_ORANGE
