#!/bin/bash
paste <(compgen -u | xargs -L1 sudo LANG=C chage -l | awk '/Password expires/ {print $NF'}) <(compgen -u)
