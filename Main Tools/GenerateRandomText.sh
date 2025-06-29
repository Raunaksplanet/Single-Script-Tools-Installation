#!/bin/bash

for i in {1..100}; do
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 10
  echo
done
