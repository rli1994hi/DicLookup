# DicLookup
Look up explanation for a list of words and output in CSV. 

Dictionary API used in this script: https://dictionaryapi.dev/. Thanks.

## Env Requirements
Test env:
1. ruby: ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin16]
1. openssl: OpenSSL 1.1.1g

Extra:
Gem [httparty](https://github.com/jnunemaker/httparty) has been installed.


## Usage: 
(Standing where dic_lookup.rb is at) 

```
$ ruby dic_lookup.rb -w hello,hi,asdf
```

## Output

The output is a csv file named as `output.csv`. It's stored under the same directory as `dic_lookup.rb`.

Output Sample:

```
$ ruby dic_lookup.rb -w hello,hi,sadf
done with hello
done with hi
wrong spelling: sadf
========================================
The definitions of valid words in the input word list is stored in output.csv.
```

