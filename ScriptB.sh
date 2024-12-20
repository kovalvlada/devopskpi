#!/bin/bash

while true; do
  curl -i -X GET 127.0.0.1/compute &
  sleep $((5 + RANDOM % 6))
done