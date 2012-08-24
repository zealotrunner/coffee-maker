# CoffeeMaker

```
       ____         __   __              __  __         _
      / ___| ___   / _| / _|  ___   ___ |  \/  |  __ _ | | __ ___  _ __
     | |    / _ \ | |_ | |_  / _ \ / _ \| |\/| | / _` || |/ // _ \| '__|
     | |___| (_) ||  _||  _||  __/|  __/| |  | || (_| ||   <|  __/| |
      \____|\___/ |_|  |_|   \___| \___||_|  |_| \__,_||_|\_\\___||_|
```

CoffeeMaker is a toolkit for creating CoffeeLangs. It's inspired by and derived from [CoffeeScript](https://github.com/jashkenas/coffee-script).

## Make a CoffeeLang

* Install [CoffeeScript](https://github.com/jashkenas/coffee-script), [Jison](https://github.com/zaach/jison)
* Make a bean
    * The name and other basic things of this CoffeeLang.
    * A lexer.
    * A parser.
    * An AST implementation.
* Run `cake --bean /path/to/bean/ build:full`

## Examples

`cake --bean example/coffee-calculator/ build:full`

* CoffeeLover
* CoffeeCalculator
* CoffeeScript (a transplanted implementation)