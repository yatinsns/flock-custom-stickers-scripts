#! /usr/bin/env ruby

META_DATA_URL = "https://mc.flock.co"

stickers_meta_data = `curl #{META_DATA_URL}`
puts "Stickers metadata : #{stickers_meta_data}"

