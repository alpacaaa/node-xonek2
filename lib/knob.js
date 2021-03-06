// Generated by CoffeeScript 1.8.0
(function() {
  var Button, Component, Knob, knobPosition,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Button = require('./button');

  Component = require('./base-component');

  Knob = (function(_super) {
    __extends(Knob, _super);

    Knob.prototype.button = null;

    Knob.prototype.channel = null;

    Knob.prototype.position = null;

    function Knob(channel, knob) {
      this.channel = channel;
      this.position = knobPosition(channel, knob);
      this.button = new Button(channel, knob);
    }

    return Knob;

  })(Component);

  knobPosition = function(channel, position) {
    var value;
    value = channel + (4 * (position + 1));
    return [190, value];
  };

  module.exports = Knob;

}).call(this);
