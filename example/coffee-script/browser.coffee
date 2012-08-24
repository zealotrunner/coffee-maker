# Override exported methods for non-Node.js engines.

CoffeeMaker = require './coffee-maker'
CoffeeMaker.require = require

# Use standard JavaScript `eval` to eval code.
CoffeeMaker.eval = (code, options = {}) ->
  options.bare ?= on
  eval CoffeeMaker.compile code, options

# Running code does not provide access to this scope.
CoffeeMaker.run = (code, options = {}) ->
  options.bare = on
  Function(CoffeeMaker.compile code, options)()

# If we're not in a browser environment, we're finished with the public API.
return unless window?

# Load a remote script from the current domain via XHR.
CoffeeMaker.load = (url, callback) ->
  xhr = new (window.ActiveXObject or XMLHttpRequest)('Microsoft.XMLHTTP')
  xhr.open 'GET', url, true
  xhr.overrideMimeType 'text/plain' if 'overrideMimeType' of xhr
  xhr.onreadystatechange = ->
    if xhr.readyState is 4
      if xhr.status in [0, 200]
        CoffeeMaker.run xhr.responseText
      else
        throw new Error "Could not load #{url}"
      callback() if callback
  xhr.send null

# Activate CoffeeMaker in the browser by having it compile and evaluate
# all script tags with a content-type of `text/coffeescript`.
# This happens on page load.
runScripts = ->
  scripts = document.getElementsByTagName 'script'
  coffees = (s for s in scripts when s.type is 'text/coffeescript')
  index = 0
  length = coffees.length
  do execute = ->
    script = coffees[index++]
    if script?.type is 'text/coffeescript'
      if script.src
        CoffeeMaker.load script.src, execute
      else
        CoffeeMaker.run script.innerHTML
        execute()
  null

# Listen for window load, both in browsers and in IE.
if window.addEventListener
  addEventListener 'DOMContentLoaded', runScripts, no
else
  attachEvent 'onload', runScripts
