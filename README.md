# DicLookup
Look up explanation for a list of word and output in CSV. 

Dictionary API used in this script: https://googledictionaryapi.eu-gb.mybluemix.net/. Thanks.

Usage: (Standing where dic_lookup.rb is at) 

```
$ ruby dic_lookup.rb -w 
```

Outputs:
```
$ ruby dic_lookup.rb -w hello,hi,absf
done with hello
done with hi
wrong spelling: absf
================Copy below as csv================
hello,"exclamation: 
1: Used as a greeting or to begin a telephone conversation.
""hello there, Katie!""

n.: 
1: An utterance of “hello”; a greeting.
""she was getting polite nods and hellos from people""

vi.: 
1: Say or shout “hello”; greet someone.
""I pressed the phone button and helloed"""
hi,"exclamation: 
1: Used as a friendly greeting or to attract attention.
""“Hi there. How was the flight?”""" 
```
