exports.Base = class Base
  constructor: (@value) ->
    @nodes = [this]

  compile: (o, lvl) ->
    (node.compileSelf(o, lvl) for node in @nodes).join('')

  push: (node) ->
    @nodes.push node
    this

exports.Article = class Article extends Base
  compileSelf: (o, lvl) ->

exports.Word = class Word extends Base
  coffees:
    'a': 'Affogato'
    'b': 'Baltimore'
    'c': 'Cappuccino'
    'd': 'Decaf'
    'e': 'Eiskaffee'
    'f': 'Frappuccino'
    'g': 'Guillermo'
    'h': 'Half-caf'
    'i': 'IcedCoffee'
    'j': 'InstantCoffee'
    'k': 'KopiSusu'
    'l': 'Libbylou'
    'm': 'Mocha'
    'n': 'N-Coffee'
    'o': 'O-Coffee'
    'p': 'Pocillo'
    'q': 'Q-Coffee'
    'r': 'Ristretto'
    's': 'SkinnyLatte'
    't': 'TurkishCoffee'
    'u': 'UltraCoffee'
    'v': 'ViennaCoffee'
    'w': 'WhiteCoffee'
    'x': 'X-Coffee'
    'y': 'Yuanyang'
    'z': 'ZebraMocha'

  compileSelf: (o, lvl) ->
    @coffees[@value.toLowerCase().charAt 0]

exports.Other = class Other extends Base
  compileSelf: (o, lvl) ->
    @value
