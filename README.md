boco-command
================================================================================

Classes and utilities for working with commands.

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


[boco-validation]: https://github.com/bocodigitalmedia/boco-validation
