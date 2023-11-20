#!/bin/sh 

mkdir "/home/codespace/workspaces"
for item in /workspaces/*; do
  ln -s "$item" "/home/codespace/workspaces/$(basename "$item")"
done