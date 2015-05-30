#! /usr/bin/env ruby

require 'json'

META_DATA_URL = "https://mc.flock.co"

stickers_meta_data_result = `curl #{META_DATA_URL}`
stickers_meta_data = JSON.parse(stickers_meta_data_result)
collections = stickers_meta_data["collections"]
sets = collections[0]["sets"]

results = {}
sets.each do |set|
  sticker_set_name = set["id"]
  set["items"].each do |item|
    sticker_name = item["name"].downcase
    sticker_id = item["id"]
    sticker_source = item["source"]
    if results[sticker_name].nil?
      results[sticker_name] = []
    end
    results[sticker_name].push sticker_source
  end
end

results.each do |key, value|
  puts "#{key} (#{value.count})"
end






