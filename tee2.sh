#!/bin/bash
compgen -u | tee >(wc -l) >(wc -m) 
