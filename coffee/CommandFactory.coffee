UnregisteredCommand = require './errors/UnregisteredCommand'

class CommandFactory

  constructor: (props = {}) ->
    @constructors = props.constructors
    @setDefaults()

  setDefaults: ->
    @constructors = {} unless @constructors?

  generateId: ->
    require('uuid').v4()

  construct: (name, props) ->
    unless @isRegistered name
      error = new UnregisteredCommand
      error.setPayload name: name
      throw error

    constructor = @constructors[name]
    command = new constructor props
    command.id = @generateId() unless command.id?

    return command

  register: (constructors = {}) ->
    @constructors[name] = constructor for own name, constructor of constructors

  isRegistered: (name) ->
    @constructors.hasOwnProperty name

module.exports = CommandFactory
