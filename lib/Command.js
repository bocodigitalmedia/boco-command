// Generated by CoffeeScript 1.7.1
(function() {
  var Command, Validation;

  Validation = require('boco-validation').Validation;

  Command = (function() {
    function Command(props) {
      if (props == null) {
        props = {};
      }
      this.id = props.id;
      this.name = props.name;
      this.setParameters(props.parameters);
      this.setDefaults();
    }

    Command.prototype.setDefaults = function() {
      if (this.name == null) {
        return this.name = this.constructor.name;
      }
    };

    Command.prototype.setParameters = function(parameters) {
      return this.parameters = parameters;
    };

    Command.prototype.validateParameters = function() {
      return new Validation({
        subject: this.parameters
      });
    };

    return Command;

  })();

  module.exports = Command;

}).call(this);

//# sourceMappingURL=Command.map