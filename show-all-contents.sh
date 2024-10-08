# カレントディレクトリ以下を探索し、ファイルの内容を表示するスクリプト

show_all_contents() {
  #!/bin/bash

  # デフォルトの深さ
  depth=2

  # オプションを解析
  while getopts "d:" opt; do
    case $opt in
      d)
        depth=$OPTARG
        ;;
      *)
        echo "Usage: $0 [-d depth]"
        exit 1
        ;;
    esac
  done

  # ファイルを探索し、内容を表示
  find . -maxdepth "$depth" -type f | while read -r file; do
    echo "----- $file -----"
    cat "$file"
    echo
  done

}
