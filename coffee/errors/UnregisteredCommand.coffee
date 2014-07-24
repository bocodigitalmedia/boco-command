CustomError = require('boco-error').CustomError

class UnregisteredCommand extends CustomError
  constructPayload: (params = {}) ->
    name: params.name

module.exports = UnregisteredCommand
