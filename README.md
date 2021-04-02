# WordLookup
Look up explanation for a list of words and output in CSV. 

Dictionary API used in this script: https://dictionaryapi.dev/. Thanks.

## Usage: 
(Standing where word_lookup.rb is at)

```
$ ruby word_lookup.rb -w hello,hi,asdf
```

If a word has multiple distinct meanings, e.g.: present, the tools seperates them with "----------". Detail see the sample CSV in [Output section](#Output)


## Output

The output is a csv file named as `output.csv`. It's stored under the same directory as `word_lookup.rb`.

Terminal Output Sample:

```
$ ruby word_lookup.rb -w candy,sadf,hi,present
done with candy
No definition found for: [sadf]. Check the spelling, or google the word directly. Skipping.
done with hi
done with present
========================================
The definitions of valid words in the input word list is stored in output.csv.
```

Sample CSV: [google spread sheet](https://docs.google.com/spreadsheets/d/1A4Hy_qq1nmuQZKlCCmQF0pUMPuVJCCcaBFAlmYYps0A/edit?usp=sharing)


## Env Requirements
Test env:
1. ruby: ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
1. openssl: OpenSSL 1.1.1g

Extra:
Gem [httparty](https://github.com/jnunemaker/httparty) has been installed.
