# The 'manifest' file of CoffeeLover. It determines(exports) the name, lexer,
# parser and some other things of CoffeeLover. These exports will be used by
# CoffeeMaker.

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

# The current CoffeeLover version number.
exports.VERSION          = '0.1.0'

# The reserved words of CoffeeLover.
exports.RESERVED         = []

# Additional commands.
exports.COMMAND_SWITCHES = []

exports.COMMAND          = 'coffee-lover'
exports.NAME             = 'CoffeeLover'
exports.EXTENSION        = '.coffeelover'

exports.TARGET_NAME      = 'CoffeeLoved'
exports.TARGET_EXTENSION = '.coffeeloved'

exports.lexer  = lexer
exports.parser = parser

exports.evalc  = (code) ->
  code