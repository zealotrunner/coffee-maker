# The CoffeeScript Lexer. Uses a series of token-matching regexes to attempt
# matches against the beginning of the source code. When a match is found,
# a token is produced, we consume the match, and start again. Tokens are in the
# form:
#
#     [tag, value, lineNumber]
#
# Which is a format that can be fed directly into [Jison](http://github.com/zaach/jison).

# Import the helpers we need.
{count, starts, compact, last} = require './helpers'

# The Lexer Class
# ---------------

# The Lexer class reads a stream of CoffeeScript and divvies it up into tagged
# tokens. Some potential ambiguity in the grammar has been avoided by
# pushing some extra smarts into the Lexer.
Lexer = class Lexer

  WHITESPACE      : /^[^\n\S]+/
  TRAILING_SPACES : /\s+$/
  NUMBER          : /^[0-9]+(\.[0-9]+)?/
  OPERATOR        : /^[\+\-\*\/\(\)\^\%]/
  CONSTANT        : /^(PI|E)\b/


  # **tokenize** is the Lexer's main method. Scan by attempting to match tokens
  # one at a time, using a regular expression anchored at the start of the
  # remaining code, or a custom recursive token-matching method
  # (for interpolations). When the next token has been recorded, we move forward
  # within the code past the token, and begin again.
  #
  # Each tokenizing method is responsible for returning the number of characters
  # it has consumed.
  #
  # Before returning the token stream, run it through the [Rewriter](rewriter.html)
  # unless explicitly asked not to.
  tokenize: (code, opts = {}) ->
    # code     = "\n#{code}" if @WHITESPACE.test code
    # code     = code.replace(/\r/g, '').replace @TRAILING_SPACES, ''

    @code    = code           # The remainder of the source code.
    @line    = opts.line or 0 # The current line.
    @tokens  = []             # Stream of parsed tokens in the form `['TYPE', value, line]`.

    # At every position, run through this list of attempted matches,
    # short-circuiting if any of them succeed. Their order determines precedence:
    # `@literalToken` is the fallback catch-all.
    i = 0
    while @chunk = code[i..]
      i += @numberTokens()     or
           @operatorTokens()   or
           @constantTokens()   or
           @whitespaceTokens() or
           @error 'syntax error'

    @tokens

  numberTokens: ->
    return 0 unless match = @NUMBER.exec @chunk
    [input] = match
    @token 'NUMBER', input
    input.length

  operatorTokens: ->
    return 0 unless match = @OPERATOR.exec @chunk
    [input] = match
    @token input, input
    input.length

  constantTokens: ->
    return 0 unless match = @CONSTANT.exec @chunk
    [input] = match
    @token 'CONSTANT', input
    input.length

  whitespaceTokens: ->
    return 0 unless match = @WHITESPACE.exec @chunk
    [input] = match
    input.length


  # Helpers
  # -------

  # Add a token to the results, taking note of the line number.
  token: (tag, value) ->
    @tokens.push [tag, value, @line]

  # Throws a syntax error on the current `@line`.
  error: (message) ->
    throw SyntaxError "#{message} on line #{ @line + 1}"


exports.lexer = new Lexer