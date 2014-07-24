boco-command
================================================================================

Classes and Utilities for working with commands.

    BocoCommand = require 'boco-command'
    assert = require 'assert'

# Command class

A common usage scenario would be to create command classes for each of the commands within your domain.

## Extending the Command class

    class SayHello extends BocoCommand.Command

You may define a method to construct the parameters for the class, and it will be called by both the Command's `constructor` and `setParameters` methods.

This is useful to provide some level of exclusivity for your command parameters, to set default values or sanitize.

      constructParameters: (params = {}) ->
        to: params.to

The `validateParameters` method by default returns a validation object (see: [boco-validation]) that can be used to add error information. You will want to call `super()` to get this preconfigured object, and then add your own errors to it and return.

      validateParameters: ->
        validation = super()
        unless @parameters.to?
          validation.addError 'to', 'must be present'
        return validation


## Constructing a command

As with most `boco` objects, you construct a command by passing in the object properties.

    sayHello = new SayHello id: 1, parameters: { to: "John Doe" }

    assert.equal 1, sayHello.id
    assert.equal 'SayHello', sayHello.name
    assert.equal "John Doe", sayHello.parameters.to

## Setting command parameters

After a command is created, you can also call `setParameters` manually.

    sayHello.setParameters to: "Jane Doe", foo: "bar"
    assert.equal "Jane Doe", sayHello.parameters.to
    assert.equal undefined, sayHello.parameters.foo

Note that `foo` is `undefined`, because it was not included via the `constructParameters` method we defined.

## Validating parameters

Since we defined validation on our class, you can call `validateParameters` on your command, which returns a `validation` object.

    # An invalid command
    sayHello.setParameters to: null
    validation = sayHello.validateParameters()
    assert validation.isInvalid()

    # A valid command
    sayHello.setParameters to: 'John Doe'
    validation = sayHello.validateParameters()
    assert validation.isValid()


# CommandFactory class

It is useful to create a command factory for a number of different command constructors and abstract their creation. The `CommandFactory` class does just that.

    factory = new BocoCommand.CommandFactory()

## Registering constructors

Once you have a new factory, you can register constructors by providing a collection, where the keys are the names and the values are the constructors themselves.

    factory.register SayHello: SayHello

    assert factory.isRegistered("SayHello")
    assert !factory.isRegistered("Foo")

## Constructing a command

You can now construct instances of commands by simply passing in the name and properties.

    command = factory.construct "SayHello", id: 2

    assert.equal 2, command.id
    assert command instanceof SayHello

## Generating default identities

The core `CommandFactory` assigns identities to the commands it creates using its prototype's `generateId`. By default, it generates v4 uuids for all commands.

You can override that method by using an extended version of the class, or simply overriding the method directly on the factory instance.

    factory.generateId = -> 1001

    command = factory.construct "SayHello"
    assert.equal 1001, command.id
    delete factory.generateId

## Unregistered constructors

If you attempt to construct a command whose name has not been registered, the `construct` method will throw an `UnregisteredCommand` error.

    constructUnregisteredCommand = -> factory.construct "Foo"

    assert.throws constructUnregisteredCommand, (error) ->
      assert error instanceof BocoCommand.Errors.UnregisteredCommand
      assert.equal "Foo", error.payload.name
      true
