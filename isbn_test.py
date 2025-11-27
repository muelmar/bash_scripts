#!/usr//bin/python3
from isbntools.app import *
import json
import sys

if len(sys.argv) == 2 :

   m = meta(sys.argv[1],service='goob')
   if m == {} :
      print ("das war nix")
   m = meta(sys.argv[1],service='wiki')
   x = registry.bibformatters['json'](m)
   y = json.loads(x)
   print(',' + y["title"])
   #print(y["author"][0]["name"])
   #print(y["publisher"])
#
