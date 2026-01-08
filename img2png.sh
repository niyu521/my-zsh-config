#!/usr/bin/env bash
set -e

# 対象フォルダ（引数がなければカレント）
TARGET_DIR="${1:-.}"

# 絶対パス化
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
OUTPUT_DIR="$TARGET_DIR/output"

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob

# 対応拡張子（大文字・小文字両対応）
FILES=(
  "$TARGET_DIR"/*.heic "$TARGET_DIR"/*.HEIC
  "$TARGET_DIR"/*.heif "$TARGET_DIR"/*.HEIF
  "$TARGET_DIR"/*.jpg  "$TARGET_DIR"/*.JPG
  "$TARGET_DIR"/*.jpeg "$TARGET_DIR"/*.JPEG
  "$TARGET_DIR"/*.png  "$TARGET_DIR"/*.PNG
  "$TARGET_DIR"/*.webp "$TARGET_DIR"/*.WEBP
  "$TARGET_DIR"/*.tif  "$TARGET_DIR"/*.TIF
  "$TARGET_DIR"/*.tiff "$TARGET_DIR"/*.TIFF
  "$TARGET_DIR"/*.bmp  "$TARGET_DIR"/*.BMP
  "$TARGET_DIR"/*.gif  "$TARGET_DIR"/*.GIF
)

count=0

for file in "${FILES[@]}"; do
  base="$(basename "$file")"
  name="${base%.*}"
  out="$OUTPUT_DIR/$name.png"

  # 同名回避
  if [[ -e "$out" ]]; then
    i=1
    while [[ -e "$OUTPUT_DIR/${name}_${i}.png" ]]; do
      i=$((i+1))
    done
    out="$OUTPUT_DIR/${name}_${i}.png"
  fi

  echo "Converting: $base -> $(basename "$out")"
  sips -s format png "$file" --out "$out" >/dev/null
  count=$((count+1))
done

echo "Done. Converted: $count files"
echo "Output folder: $OUTPUT_DIR"
