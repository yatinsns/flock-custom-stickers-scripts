# Description
#  Display a custom domain sticker for Riva.
#
# Configuration:
#   keyword.txt - List of keywords for stickers. Located at Hubot root.
#   sticker_generator.rb - ruby script to create custom sticker with passed arguments
#
# Commands:
#  hubot sticker

module.exports = (robot) ->
  robot.respond /sticker (.*)/i, (msg) ->
    { spawn } = require 'child_process'

    args = msg.match[1]
    whitespaceIndex = args.indexOf(' ')
    subject = args.substring(0, whitespaceIndex)
    action = args.substring(whitespaceIndex + 1)

    s = spawn './sticker_generator.rb', [subject, action]
    s.stdout.on 'data', ( data ) -> msg.send (data)
