#!/usr/bin/env bash

count=$(bash -c "sudo apt update" &> /dev/null && echo "-1 + $(apt list --upgradable | wc -l)" | bc)

[[ "$count" != "0" ]] && echo $count || echo '-'
# count=$(checkupdates | wc -l) # arch
