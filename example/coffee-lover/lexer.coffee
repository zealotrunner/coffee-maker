# The CoffeeLover Lexer. Uses a series of token-matching regexes to attempt
# matches against the beginning of the source code. When a match is found,
# a token is produced, we consume the match, and start again. Tokens are in the
# form:
#
#     [tag, value, lineNumber]
#
# Which is a format that can be fed directly into [Jison](http://github.com/zaach/jison).

# The Lexer Class
# ---------------

# The Lexer class reads a stream of CoffeeScript and divvies it up into tagged
# tokens. Some potential ambiguity in the grammar has been avoided by
# pushing some extra smarts into the Lexer.
Lexer = class Lexer

  WORD  : /^[a-zA-Z]+/
  OTHER : /^[^a-zA-Z]+/

  # **tokenize** is the Lexer's main method. Scan by attempting to match tokens
  # one at a time, using a regular expression anchored at the start of the
  # remaining code, or a custom recursive token-matching method
  # (for interpolations). When the next token has been recorded, we move forward
  # within the code past the token, and begin again.
  #
  # Each tokenizing method is responsible for returning the number of characters
  # it has consumed.
  #
  tokenize: (code, opts = {}) ->
    @code    = code           # The remainder of the source code.
    @line    = opts.line or 0 # The current line.
    @tokens  = []             # Stream of parsed tokens in the form `['TYPE', value, line]`.

    # At every position, run through this list of attempted matches,
    # short-circuiting if any of them succeed. Their order determines precedence:
    # `@literalToken` is the fallback catch-all.
    i = 0
    while @chunk = code[i..]
      i += @wordTokens() or
           @otherTokens()
    @tokens

  wordTokens: ->
    return 0 unless match = @WORD.exec @chunk
    [input] = match
    @token 'WORD', input
    input.length

  otherTokens: ->
    return 0 unless match = @OTHER.exec @chunk
    [input] = match
    @line++ if input is '\n'
    @token 'OTHER', input
    input.length

  # Helpers
  # -------

  # Add a token to the results, taking note of the line number.
  token: (tag, value) ->
    @tokens.push [tag, value, @line]


exports.lexer = new Lexer