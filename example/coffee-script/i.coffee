# The 'manifest' file of CoffeeLover. It determines(exports) the name, lexer,
# parser and some other things of CoffeeLover. These exports will be used by
# CoffeeMaker.

vm                = require 'vm'

{lexer, RESERVED} = require './lexer'
{parser}          = require './parser'
parser.yy         = require './nodes'

# The real Lexer produces a generic stream of tokens. This object provides a
# thin wrapper around it, compatible with the Jison API. We can then pass it
# directly as a "Jison lexer".
parser.lexer =
  lex: ->
    [tag, @yytext, @yylineno] = @tokens[@pos++] or ['']
    tag
  setInput: (@tokens) ->
    @pos = 0
  upcomingInput: ->
    ""

# The current CoffeeScript version number.
exports.VERSION = '1.3.3'

exports.NAME = 'CoffeeScript'
exports.COMMAND = 'coffee'
exports.EXTENSION = '.coffee'
exports.TARGET_NAME = 'JavaScript'
exports.TARGET_EXTENSION = '.js'

exports.RESERVED = RESERVED

exports.COMMAND_SWITCHES = [
  ['-b', '--bare',            'compile without a top-level function wrapper']
  ['-j', '--join [FILE]',     'concatenate the source CoffeeScript before compiling']
  ['-r', '--require [FILE*]', 'require a library before executing your script']
]

exports.lexer = lexer
exports.parser = parser

# Evaluate a string of Javascript (in a Node.js-like environment).
# Called by CoffeeMaker.eval
exports.evalc = (code, sandbox) ->
  return unless code = code.trim()

  if sandbox is global
    vm.runInThisContext code
  else
    vm.runInContext code, sandbox