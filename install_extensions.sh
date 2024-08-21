#!/bin/bash

# Check if the text file exists
if [ ! -f extensions.txt ]; then
  echo "File extensions.txt not found!"
  exit 1
fi

# Read each line in the file and install the extension
while IFS= read -r extension; do
  if [ -n "$extension" ]; then
    echo "Installing $extension..."
    code --install-extension "$extension"
  fi
done < extensions.txt

