class CommandFactory

  constructor: (props = {}) ->
    @constructors = props.constructors
    @setDefaults()

  setDefaults: ->
    @constructors = {} unless @constructors?

  construct: (name, props) ->

    unless @constructors.hasOwnProperty name
      error = new Error "Command not registered: #{name}"
      error.name = "CommandNotRegistered"
      throw error

    constructor = @constructors[name]
    command = new constructor props
    command.id = @generateId() unless command.id?
    return command

  register: (constructors) ->
    @constructors[name] = constructor for own name, constructor of constructors

module.exports = CommandFactory
