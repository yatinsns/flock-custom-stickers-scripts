# Description
#  Display a custom domain sticker for Riva.
#
# Configuration:
#   keyword.txt - List of keywords for stickers. Located at Hubot root.
#   sticker_generator.rb - ruby script to create custom sticker with passed arguments
#
# Commands:
#  hubot sticker <optional-person-name> <text>

{ spawn } = require 'child_process'

module.exports = (robot) ->
  robot.respond /sticker (.*)/i, (msg) ->
    s = spawn './sticker_generator.rb', [msg.match[1]]
    s.stdout.on 'data', (data) -> msg.send (data)
