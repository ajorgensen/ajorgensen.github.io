#!/usr/bin/env bash

# Check if title is provided
if [ -z "$1" ]; then
  echo "Error: Post title is required."
  echo "Usage: $0 \"Post Title\""
  exit 1
fi

# Get the title from the first argument
TITLE="$1"

# Convert title to filename-friendly format
FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:] .-' | tr ' ' '-')
FILENAME="${FILENAME}.md"

# Create the post using hugo new content
hugo new content "posts/${FILENAME}"

echo "Created: posts/${FILENAME}"
