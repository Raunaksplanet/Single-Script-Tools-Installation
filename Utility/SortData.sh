#!/bin/bash

awk '{ print $0, length($0) }' ss | sort -k2,2n | awk '{ print $1 }' > asdf
