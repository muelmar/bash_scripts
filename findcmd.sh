#!/bin/bash
find . -name '*.sh' -exec sh -c 'for file do
   ls -l "$file"; done' sh {} +
