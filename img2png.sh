#!/usr/bin/env bash
set -e

# --------------------
# options
# --------------------
RENAME=false
START=1
PREFIX="IMG_"
DIGITS=4
TARGET_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r) RENAME=true; shift ;;
    -s) START="$2"; shift 2 ;;
    *) TARGET_DIR="$1"; shift ;;
  esac
done

# --------------------
# paths
# --------------------
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
OUTPUT_DIR="$TARGET_DIR/output"
mkdir -p "$OUTPUT_DIR"

# --------------------
# counter
# --------------------
index=0
converted=0

# --------------------
# main
# --------------------
find "$TARGET_DIR" -maxdepth 1 -type f \
  \( -iname "*.heic" -o -iname "*.heif" \
     -o -iname "*.jpg" -o -iname "*.jpeg" \
     -o -iname "*.png" \
     -o -iname "*.webp" \
     -o -iname "*.tif" -o -iname "*.tiff" \
     -o -iname "*.bmp" \
     -o -iname "*.gif" \) \
  | LC_ALL=C sort \
  | while IFS= read -r file; do

      if $RENAME; then
        num=$((START + index))
        printf -v out_name "%s%0*d.png" "$PREFIX" "$DIGITS" "$num"
      else
        base="$(basename "$file")"
        name="${base%.*}"
        out_name="$name.png"
      fi

      out_path="$OUTPUT_DIR/$out_name"

      echo "Converting: $(basename "$file") -> $out_name"
      sips -s format png "$file" --out "$out_path" >/dev/null

      index=$((index + 1))
      converted=$((converted + 1))
done

echo "Done."
echo "Converted: $converted files"
echo "Output: $OUTPUT_DIR"
