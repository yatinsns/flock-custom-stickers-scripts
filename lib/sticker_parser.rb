#! /usr/bin/env ruby
require 'json'

def fetch_sticker_meta_data(url)
  meta_data = `curl #{url}`
  JSON.parse meta_data
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

def download_stickers_from_parsed_info(parsed_info)
  parsed_info.each do |key, value|
    puts "#{key} (#{value.count})"
    dir_name = key.gsub(' ', '-')
    `mkdir ../stickers/#{dir_name}`
    index = 0
    value.each do |url|
      `curl #{url} > ../stickers/#{dir_name}/#{index}.png`
      index = index + 1
    end
  end
end

def save_names_from_parsed_info(parsed_info, path)
  File.open(path, "w+") do |f|
    parsed_info.each do |key, value|
      f.puts(key)
    end
  end
end

def main
  parsed_info = parsed_info_from_meta_data(fetch_sticker_meta_data ARGV[0])
  save_names_from_parsed_info(parsed_info, "../keywords.txt")
  download_stickers_from_parsed_info parsed_info
end

main if __FILE__ == $0
