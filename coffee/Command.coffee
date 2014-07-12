Validation = require('boco-validation').Validation

class Command

  constructor: (props = {}) ->
    @id = props.id
    @name = props.name
    @setParameters props.parameters
    @setDefaults()

  setDefaults: ->
    @name = @constructor.name unless @name?

  setParameters: (parameters) ->
    @parameters = parameters

  validateParameters: ->
    new Validation subject: @parameters


module.exports = Command
