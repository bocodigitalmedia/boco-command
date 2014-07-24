boco-command
================================================================================

Classes and Utilities for working with commands.

    BocoCommand = require 'boco-command'
    assert = require 'assert'

# Command class

A common usage scenario would be to create command classes for each of the commands within your domain.

## Extending the Command class

    class SayHello extends BocoCommand.Command

      constructParameters: (params = {}) ->
        to: params.to

      validateParameters: ->
        validation = super()
        unless @parameters.to?
          validation.addError 'to', 'must be present'
        return validation


## Constructing a command

    sayHello = new SayHello id: 1, parameters: { to: "John Doe" }

    assert.equal 1, sayHello.id
    assert.equal 'SayHello', sayHello.name
    assert.equal "John Doe", sayHello.parameters.to

## Setting command parameters

    sayHello.setParameters to: "Jane Doe"
    assert.equal "Jane Doe", sayHello.parameters.to

## Validating parameters

    # An invalid command
    sayHello.setParameters to: null
    validation = sayHello.validateParameters()
    assert validation.isInvalid()

    # A valid command
    sayHello.setParameters to: 'John Doe'
    validation = sayHello.validateParameters()
    assert validation.isValid()


# CommandFactory class

    factory = new BocoCommand.CommandFactory()

## Registering constructors

    factory.register SayHello: SayHello

## Constructing a command

    command = factory.construct "SayHello", id: 2
    assert.equal 2, command.id
    assert command instanceof SayHello

## Generating default identities

    factory.generateId = -> 1001

    command = factory.construct "SayHello"
    assert.equal 1001, command.id
    delete factory.generateId

## Unregistered constructors

    shouldThrow = -> factory.construct "Unregistered"
    assert.throws shouldThrow, (error) ->
      error.name is "CommandNotRegistered"
