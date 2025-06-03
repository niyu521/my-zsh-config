# aliasを記述するファイル。.zshrc に記述すると長くなるため、分割している。

alias c='code'
alias cc='code .'
alias cs='cursor'
alias csc='cursor .'

alias o='open'
alias oc='open .'

alias l='cd ~/Documents/02_Code/document/univ_class && ls'
alias zho='code ~/my-zsh-config && code -r ~/.zshrc'
alias zhs='source ~/.zshrc && commit_and_push'
alias cb='cd ..'
alias codi='cd ~/Documents/02_Code'

alias mft='cd ~/Documents/02_Code/project/matsufes2024_test'
alias maf='cd ~/Documents/02_Code/project/Matsufes2024'
alias write='cat >'
alias show='show_all_contents'

alias doc='cd ~/Documents/02_Code/document/univ_class'
alias bs='cd ~/Documents/02_Code/document/bs'
alias univ='cd ~/Documents/02_Code/univ'
alias genpro='cd ~/Documents/02_Code/univ/genpro'

alias cl='clear'

mcd() {
  mkdir -p "$1" && cd "$1"
}




# genpro
alias gp='./gp'
alias lpp='./lpp'
alias ll='./lldb'
alias mc='make clean'


# write() {
#   local filename=$1
#   cat > "$filename"
# }

