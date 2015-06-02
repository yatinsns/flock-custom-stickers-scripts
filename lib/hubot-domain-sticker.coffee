# Description
#  Display a custom domain sticker for Riva.
#
# Configuration:
#   keyword.txt - List of keywords for stickers. Located at Hubot root.
#   sticker_generator.rb - ruby script to create custom sticker with passed arguments
#
# Commands:
#  hubot sticker <text>

{ spawn } = require 'child_process'

module.exports = (robot) ->
  robot.respond /sticker (.*)/i, (msg) ->
    exec = require('child_process').exec
    exec "./sticker_generator.rb #{msg.match[1]}", (error, stdout, stderr) =>
         @robot.logger.debug stderr
         msg.envelope.messageType = 'sticker'
         msg.send stdout
