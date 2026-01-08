#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./img2png.sh [options] [folder]

Options:
  -r, --rename           Rename outputs to IMG_0001.png, IMG_0002.png, ...
  -s, --start N          Start number for renaming (default: 1)
  --name-prefix STR      Prefix for renaming (default: IMG_)
  -d, --digits N         Zero-pad digits (default: 4)
  -h, --help             Show help

Behavior:
  - Target folder defaults to current directory.
  - Creates <target>/output and writes PNGs there.
  - Converts: heic/heif/jpg/jpeg/png/webp/tif/tiff/bmp/gif
  - Non-recursive (only top-level). You can change easily.
EOF
}

RENAME=false
START=1
NAME_PREFIX="IMG_"
DIGITS=4
TARGET="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--rename) RENAME=true; shift ;;
    -s|--start)
      [[ $# -ge 2 ]] || { echo "Error: --start requires a number"; exit 1; }
      START="$2"; shift 2 ;;
    --name-prefix)
      [[ $# -ge 2 ]] || { echo "Error: --name-prefix requires a string"; exit 1; }
      NAME_PREFIX="$2"; shift 2 ;;
    -d|--digits)
      [[ $# -ge 2 ]] || { echo "Error: --digits requires a number"; exit 1; }
      DIGITS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    -*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

# Validate target
if [[ -z "${TARGET:-}" ]]; then
  echo "Error: target folder is empty"
  exit 1
fi
if [[ ! -d "$TARGET" ]]; then
  echo "Error: folder not found: $TARGET"
  exit 1
fi

TARGET_ABS="$(cd "$TARGET" && pwd)"
OUT_DIR="$TARGET_ABS/output"
mkdir -p "$OUT_DIR"

# Collect files (non-recursive). No mapfile. Works in bash/zsh.
# Use NUL-safe pipeline.
FILES_SORTED="$(
  find "$TARGET_ABS" -maxdepth 1 -type f \
    \( -iname "*.heic" -o -iname "*.heif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.tif" -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.gif" \) \
    ! -name ".*" -print0 \
  | perl -0pe 's/\0/\n/g' \
  | LC_ALL=C sort
)"

if [[ -z "$FILES_SORTED" ]]; then
  echo "No image files found in: $TARGET_ABS"
  exit 0
fi

i=0
converted=0
total=0

# Read line-by-line safely (paths with spaces OK; newlines in filenamesは通常想定外)
while IFS= read -r src; do
  [[ -n "$src" ]] || continue
  total=$((total+1))

  base="$(basename "$src")"
  name="${base%.*}"

  if $RENAME; then
    num=$((START + i))
    printf -v out_name "%s%0*d.png" "$NAME_PREFIX" "$DIGITS" "$num"
    out_path="$OUT_DIR/$out_name"
  else
    out_path="$OUT_DIR/${name}.png"
    # avoid overwrite by suffix
    if [[ -e "$out_path" ]]; then
      k=1
      while [[ -e "$OUT_DIR/${name}_${k}.png" ]]; do
        k=$((k+1))
      done
      out_path="$OUT_DIR/${name}_${k}.png"
    fi
  fi

  if sips -s format png "$src" --out "$out_path" >/dev/null 2>&1; then
    converted=$((converted+1))
  else
    echo "Failed: $src"
  fi

  i=$((i+1))
done <<< "$FILES_SORTED"

echo "Done. Converted: $converted / $total"
echo "Output folder: $OUT_DIR"
