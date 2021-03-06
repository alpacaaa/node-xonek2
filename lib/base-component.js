// Generated by CoffeeScript 1.8.0
(function() {
  var Component, EventEmitter,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  EventEmitter = require('events').EventEmitter;

  Component = (function(_super) {
    __extends(Component, _super);

    function Component() {
      return Component.__super__.constructor.apply(this, arguments);
    }

    Component.prototype.value = 0;

    Component.prototype.updateValue = function(value, msg) {
      this.value = value;
      return this.emit('update', value, msg);
    };

    return Component;

  })(EventEmitter);

  module.exports = Component;

}).call(this);
