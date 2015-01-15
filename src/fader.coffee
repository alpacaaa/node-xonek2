

Component = require './base-component'


class Fader extends Component
  constructor: (channel) ->
    @channel  = channel
    @position = [190, 16 + channel]

module.exports = Fader
