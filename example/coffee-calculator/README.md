CoffeeCalculator
----------------

A basic calculator that supports + - * / ^ E PI

The 'code'

    1 + (2 - 3) * 4 / 5 ^ 6 + PI

will be compiled to

    eval('1 + (2 - 3) * 4 / Math.pow(5, 6) + Math.PI')