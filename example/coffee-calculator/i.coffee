# The 'manifest' file of CoffeeLover. It determines(exports) the name, lexer,
# parser and some other things of CoffeeLover. These exports will be used by
# CoffeeMaker.

vm        = require 'vm'

{lexer}   = require './lexer'
{parser}  = require './parser'

parser.yy = require './nodes'


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

# The current CoffeeCalculator version number.
exports.VERSION = '0.1.0'

exports.NAME = 'CoffeeCalculator'
exports.COMMAND = 'coffee-calculator'
exports.EXTENSION = '.cc'

exports.TARGET_NAME = 'JavaScript'
exports.TARGET_EXTENSION = '.js'

exports.lexer = lexer
exports.parser = parser

exports.evalc = (code) ->
  return unless code = code.trim()
  vm.runInThisContext code