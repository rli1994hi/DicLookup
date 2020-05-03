# Usage: (Standing where dic_lookup.rb is at) ruby dic_lookup.rb -w hello,hi,dsdf

# TODO: 
# 1. Seems PART_OF_SPEECH_MAP is output as files
# 2. Clean up, use JSON map to the original response, README and modulization

require 'net/http'
require 'optparse'
require 'httparty'

URL_PATTERN = "https://api.dictionaryapi.dev/api/v2/entries/en/hello"

PART_OF_SPEECH_MAP = {"adjective" => "adj.", "adverb" => "adv.", "noun" => "n.", "preposition" => "prep.", "verb" => "v.", "conjunction" => "conjunction", "interjection" => "interjection" , "intransitive verb" => "vi.", "transitive verb" => "vt.", }

def grab_def(word_list)
  word_def_list = []

  word_list.each do |word|
    word_def = WordDef.new
    word_def.word = word

    response = get_response(construct_url(word))
    if response.include?("Word not found")
      puts "wrong spelling: #{word}\n"
      next
    end
    response = JSON.parse(response).first

    meaning_list = response["meanings"]
    def_str = ""
    meaning_list.each do |meaning|
      meaning.each do |k, v|
        case k
        when "partOfSpeech"
          def_str += "#{get_part_of_speech_abbr(v)}: \n"
        when "definitions"
          def_str += def_list_str(v) + "\n"
        end
      end
    end

    word_def.def_str = def_str.strip!
    word_def_list << word_def
    puts "done with #{word}"
  end
  print_word_def_list(word_def_list)
end

def construct_url(word)
  URL_PATTERN.gsub("hello", word)
end

def get_response(uri_str)
  response = HTTParty.get(uri_str).body
end

def get_part_of_speech_abbr(pos)
  abbr = PART_OF_SPEECH_MAP[pos] 
  abbr.nil? ? pos : abbr
end

def def_list_str(def_list)
  str = ""
  def_index = 0
  def_list.each do |ele|
    def_index += 1
    ele.each do |k, v|
      case k
      when "definition"
        str += "#{def_index}: #{v}\n"
      when "example"
        str += "\"#{v}\"\n"
      end
    end
  end
  str
end


def print_word_def_list(word_def_list)
  puts "================Copy below as csv================"

  c = CSV.generate do |csv|
    word_def_list.each do |word_def|
      csv << [word_def.word, word_def.def_str]
    end
  end
  puts c
end

class WordDef
  attr_accessor :word, :def_str
  def initialize(word = nil, def_str = nil)
    @word = word
    @def_str = def_str
  end
end

options = {}
option_parser = OptionParser.new do |opt|
  opt.on("-w word_list", Array, "The list of words needs to have definitions for") do |list|
    options[:word_list] = list 
  end
end

option_parser.parse!
grab_def(options[:word_list])