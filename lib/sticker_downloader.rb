#! /usr/bin/env ruby
require 'json'

def fetch_sticker_meta_data(url)
  `curl #{url} > ./sticker.json`
  #JSON.parse meta_data
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
    dir_path = "../stickers/#{dir_name}"
    `mkdir -p #{dir_path}` unless File.directory? dir_path
    index = 0
    value.each do |url|
      `curl #{url} > ../stickers/#{dir_name}/#{index}.png`
      index = index + 1
    end
  end
end

def save_parsed_info(parsed_info, path)
  File.open(path, "w+") do |f|
    parsed_info.each do |key, value|
      value.each { |url| f.puts("#{key}=>#{url}")}
    end
  end
end

def main
  fetch_sticker_meta_data ARGV[0]
  #parsed_info = parsed_info_from_meta_data(fetch_sticker_meta_data ARGV[0])
  #save_parsed_info(parsed_info, "../sticker_info.txt")
end

main if __FILE__ == $0
