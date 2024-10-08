# 自動で.zshrcをコミットするスクリプト

commit_and_push() {
  # 元のディレクトリを保存
  local original_dir=$(pwd)
  
  # リポジトリのパスを定義
  local repo_path="$HOME/my-zsh-config"
  
  # 現在のタイムスタンプを取得
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  
  # タイムスタンプを含むログファイルを作成/更新
  echo "source ~./zshrc executed at ${timestamp}" > $repo_path/.zshrc_commit_log.txt
  
  # リポジトリディレクトリに移動
  cd $repo_path
  
  # 無視されているファイルも強制的に追加
  git add -f .zshrc .zshrc_commit_log.txt ./my-zsh-config/*
  
  # リモートリポジトリから最新の変更をプル
  git pull origin main
  
  # タイムスタンプを含むメッセージで変更をコミット
  git commit -m "source ~./zshrc executed at ${timestamp}"
  
  # 変更をリモートリポジトリにプッシュ
  git push origin main
  
  # 元のディレクトリに戻る
  cd $original_dir
}
