#! /usr/bin/env ruby

require 'json'

def sticker_url_for_text(words)
  random_sticker_url_with_key words.join(" ")
end

def custom_url(person_name, text)
  return nil
end

def random_sticker_url_with_key(key)
  meta_data = File.read('./stickers.json')
  stickers_data = JSON.parse meta_data
  stickers_info = parsed_info_from_meta_data stickers_data
  sticker_set = stickers_info[key]  
  url = sticker_set[rand(sticker_set.length)] unless sticker_set.nil?
  url
end

def parsed_info_from_meta_data(meta_data)
  collections = meta_data["collections"]
  sets = collections[0]["sets"]

  results = {}
  sets.each do |set|
    sticker_set_name = set["id"]
    set["items"].each do |item|
      sticker_name = encode item["name"]
      sticker_source = item["source"]
      update_results(results, sticker_name, sticker_source)
    end
  end
  results
end

def encode(string)
  string.downcase.gsub("(", "").gsub(")", "").gsub("'", "").gsub("?", "")
end

def update_results(results, key, value)
  if results[key].nil?
    results[key] = []
  end
  results[key].push value
end

def main
  url = sticker_url_for_text ARGV
  print url.chomp unless url.nil?
end

main if __FILE__ == $0
