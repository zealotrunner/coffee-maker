fs            = require 'fs'
path          = require 'path'
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors.
enableColors = no
unless process.platform is 'win32'
  enableColors = not process.env.NODE_DISABLE_COLORS

bold = red = green = reset = ''
if enableColors
  bold  = '\x1B[0;1m'
  red   = '\x1B[0;31m'
  green = '\x1B[0;32m'
  reset = '\x1B[0m'

# Built file header.
header = """
  /**
   * CoffeeMaker Compiler v
   *
   * Copyright 2012, Sean Zheng
   * Released under the MIT License
   */
"""

# Run a CoffeeLang through our node/coffee interpreter.
run = (args, cb) ->
  proc =         spawn 'coffee', args
  proc.stderr.on 'data', (buffer) -> log buffer.toString()
  proc.on        'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'

# Log a message with a color.
log = (message, color = '', explanation = '') ->
  console.log color + message + reset + ' ' + (explanation or '')

option '-p', '--prefix [DIR]', 'set the installation prefix for `cake install`'
option '-b', '--bean [DIR]', 'set the bean path for `cake build:all` and `cake install`'

task 'build:full', 'build the CoffeeLang from source', (options) ->
  bean = options.bean
  if not bean
    log '--bean [DIR] is required', red
    process.exit 1

  exec([
    "cake --bean #{options.bean} build"
    "cake --bean #{options.bean} build:parser"
    "cake --bean #{options.bean} build:bin"
  ].join(' && '), (err, stdout, stderr) ->
    log stdout.trim() if stdout
    if err then log stderr.trim() else log 'done', green
  )

task 'build', 'build the CoffeeMaker from source', (options) ->
  bean = options.bean
  if not bean
    log '--bean [DIR] is required', red
    process.exit 1

  beanname = path.basename bean

  log "Building CoffeeMaker"
  makerfiles = fs.readdirSync 'src'
  makerfiles = ('src/' + file for file in makerfiles when file.match(/\.coffee$/))

  log "Building #{bean}"
  beanfiles = fs.readdirSync bean
  beanfiles = (options.bean + file for file in beanfiles when file.match(/\.coffee$/))

  files = makerfiles.concat beanfiles

  run ['-c', '-o', "lib/#{beanname}"].concat(files)

task 'build:parser', 'build CoffeeLang parser', (options) ->
  bean = options.bean
  if not bean
    log '--bean [DIR] is required', red
    process.exit 1

  beanname = path.basename bean

  log "Building #{bean} Parser"
  {extend} = require "./lib/#{beanname}helpers"
  require 'jison'

  extend global, require('util')
  parser = require("./lib/#{beanname}grammar").parser
  fs.writeFile "./lib/#{beanname}parser.js", parser.generate()

task 'build:bin', 'build CoffeeLang bin', (options) ->
  bean = options.bean
  if not bean
    log '--bean [DIR] is required', red
    process.exit 1

  beanname = path.basename bean

  log "Building #{bean} bin"
  {COMMAND} = require "./lib/#{beanname}i"
  exec "mkdir -p ./bin", (err, stdout, stderr) ->
    fs.writeFile "./bin/#{COMMAND}",
      [
        "#!/usr/bin/env node"
        ""
        "var path = require('path');"
        "var fs   = require('fs');"
        "var lib  = path.join(path.dirname(fs.realpathSync(__filename)), '../lib');"
        ""
        "require(lib + '/#{COMMAND}/command').run();"
      ].join('\n'),
      (err, stdout, stderr) ->
        exec "chmod +x ./bin/#{COMMAND}"


# task 'install', 'install CoffeeLang into /usr/local (or --prefix)', (options) ->
#   bean = options.bean
#   beanname = path.basename bean
#   base = options.prefix or '/usr/local'
#   lib  = "#{base}/lib/#{beanname}"
#   bin  = "#{base}/bin"
#   node = "~/.node_libraries/coffee-script"
#   log   "Installing #{beanname} to #{lib}"
#   log   "Linking to #{node}"
#   log   "Linking 'coffee' to #{bin}/coffee"
#   exec([
#     "mkdir -p #{lib} #{bin}"
#     "cp -rf bin lib LICENSE README package.json src #{lib}"
#     "ln -sfn #{lib}/bin/coffee #{bin}/coffee"
#     "ln -sfn #{lib}/bin/cake #{bin}/cake"
#     "mkdir -p ~/.node_libraries"
#     "ln -sfn #{lib}/lib/#{basename} #{node}"
#   ].join(' && '), (err, stdout, stderr) ->
#     if err then log stderr.trim() else log 'done', green
#   )
