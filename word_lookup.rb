# Usage: (Standing where word_lookup.rb is at) ruby word_lookup.rb -w hello,hi,dsdf

# TODO: 
# 1. Seems PART_OF_SPEECH_MAP is output as files
# 2. Clean up, use JSON map to the original response, README and modulization

require 'net/http'
require 'optparse'
require 'httparty'

URL_PATTERN = "https://api.dictionaryapi.dev/api/v2/entries/en/hello"

PART_OF_SPEECH_MAP = {"adjective" => "adj.", "adverb" => "adv.", "noun" => "n.", "preposition" => "prep.", "verb" => "v.", "conjunction" => "conjunction", "interjection" => "interjection" , "intransitive verb" => "vi.", "transitive verb" => "vt."}

DEF_NOT_FOUND_STRINGS = ["Word not found", "No Definitions Found"]

def grab_def(word_list)
  top_word_def_list = [] 

  word_list.each do |word|
    response = get_response(construct_url(word))
    unless has_def?(response)
      puts "No definition found for: [#{word}]. Check the spelling, or google the word directly. Skipping.\n"
      next
    end

    top_word_def = TopWordDef.new
    top_word_def.word = word

    # word_def = SingleWordDef.new
    # word_def.word = word    

    # response = JSON.parse(response).first
    responses = JSON.parse(response)

    responses.each do |response|
        parse_single_response(response, top_word_def)
    end

    top_word_def_list << top_word_def
    puts "done with #{word}"
  end

  # top_word_def_list.each do |top_word_def|
  #   puts top_word_def.def_list_str
  # end
  output_word_def_list(top_word_def_list)
end

def parse_single_response(response, top_word_def)
    word_def = SingleWordDef.new(top_word_def.word)
    phonetic = response["phonetic"]
    word_def.phonetic = phonetic
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
    top_word_def.def_list << word_def
end

def has_def?(response)
    DEF_NOT_FOUND_STRINGS.each do |str|
        return false if response.include?(str)
    end
    return true
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


def output_word_def_list(top_word_def_list)
  c = CSV.generate do |csv|
    top_word_def_list.each do |top_word_def|
      csv << [top_word_def.word, top_word_def.def_list_str]
    end
  end

  File.open("output.csv", 'w') { |file| file.write(c) }

  puts "========================================"
  puts "The definitions of valid words in the input word list is stored in output.csv."
end

class TopWordDef
    # word: the word that the tool is working for
    # def_list: a list of SingleWordDef
    attr_accessor :word, :def_list

    def initialize(word = nil, def_list = nil)
        @word = word
        @def_list = def_list || []
    end

    def def_list_str
        def_str_list = @def_list.map { |word_def| word_def.def_str }
        def_str_list.join("\n\n----------------\n\n")
    end
end

class SingleWordDef
  attr_accessor :word, :def_str, :phonetic
  def initialize(word = nil, def_str = nil, phonetic = nil)
    @word = word
    @def_str = def_str
    @phonetic = phonetic
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