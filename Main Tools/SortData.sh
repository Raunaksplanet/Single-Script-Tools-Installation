#!/bin/bash

awk '{ print $0, length($0) }' ss | sort -k2,2n | awk '{ print $1 }' > asdf
# awk '{ print length, $0 }' input.txt | sort -n | cut -d" " -f2-
