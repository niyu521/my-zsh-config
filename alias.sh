# aliasを記述するファイル。.zshrc に記述すると長くなるため、分割している。

alias c='code'
alias cc='code .'
alias csc='cursor .'
cs() {
  cursor "$@"
}


alias l='cd ~/Documents/02_Code/document/univ_class && ls'
alias zho='code ~/my-zsh-config && code -r ~/.zshrc'
alias zhs='source ~/.zshrc && commit_and_push'
alias cb='cd ..'
alias codi='cd ~/Documents/02_Code'
alias o='open .'
alias mft='cd ~/Documents/02_Code/project/matsufes2024_test'
alias maf='cd ~/Documents/02_Code/project/Matsufes2024'
alias write='cat >'
alias show='show_all_contents'

alias doc='cd ~/Documents/02_Code/document/univ_class'
alias univ='cd ~/Documents/02_Code/univ'
alias genpro='cd ~/Documents/02_Code/univ/genpro'



# write() {
#   local filename=$1
#   cat > "$filename"
# }

