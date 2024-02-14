#!/usr/bin/env bash

# Check if Image file is provided
if [ $# -ne 1 ]; then
  echo "Please provide an image file as an argument."
  exit 1
fi

# Get the image filename and extension
image_file="$1"
image_ext="${image_file##*.}"

# Check if file exists and extension is valid
if [ ! -f "$image_file" ]; then
  echo "Error: File '$image_file' does not exist."
  exit 1
fi

if [[ ! "$image_ext" =~ ^(png|jpg|jpeg)$ ]]; then
  echo "Error: Unsupported image format. Please provide a PNG, JPG, or JPEG image."
  exit 1
fi

# Define output directory and sizes
output_dir="."
sizes=(16 32 48 64 72 96 144 152 192 256 310 512)

# Ensure ImageMagick is installed
if [ ! -f "$(command -v convert)" ]; then
  echo "Error: ImageMagick is required. Please install it before running this script."
  exit 1
fi

# Generate favicons in different sizes
for size in "${sizes[@]}"; do
  output_file="${output_dir}/favicon-${size}.png"
  convert "$image_file" -resize "${size}x${size}" -background none "$output_file"
done

# Generate .ico file with appropriate sizes
convert -layers flatten "${output_dir}"/favicon-*.png "${output_dir}"/favicon.ico

echo "Favicons generated successfully in '${output_dir}' directory."
