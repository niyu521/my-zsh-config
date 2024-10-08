# 自動でコミットするスクリプト
#!/bin/zsh

# 自動コミットとプッシュを行う関数
commit_and_push() {
    # Gitリポジトリのパスを指定（例: ~/my-zsh-config）
    local repo_path=~/my-zsh-config

    # リポジトリの存在を確認
    if [ ! -d "$repo_path/.git" ]; then
        echo "This directory is not a Git repository: $repo_path"
        return 1
    fi
    
    # リポジトリディレクトリに移動
    cd "$repo_path" || {
        echo "Failed to change directory to $repo_path"
        return 1
    }

    # 現在の日時を取得してコミットメッセージに含める
    local current_time=$(date "+%Y-%m-%d %H:%M:%S")
    
    # 変更をステージング
    git add -A
    
    # 変更があるかどうかを確認
    if git diff --cached --quiet; then
        echo "No changes to commit."
        return 0
    fi

    # コミットメッセージを設定してコミット
    git commit -m "Auto-commit: changes made at $current_time"
    
    # リモートリポジトリにpush
    git push origin main
    
    # 結果を表示
    if [ $? -eq 0 ]; then
        echo "Changes successfully pushed to the repository."
    else
        echo "Failed to push changes to the repository."
        return 1
    fi
}
