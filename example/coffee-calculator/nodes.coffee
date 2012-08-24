exports.Expression = class Expression
  constructor: (@value) ->

  compile: (o, lvl) ->
    @value

exports.Calculator = class Calculator
  constructor: (@value) ->

  compile: (o, lvl) ->
    "eval('#{@value}')"