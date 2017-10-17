# ----- PATH ----- #
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:~/.composer/vendor/bin:$PATH

# ----- Aliases ----- #

# --- General ---
alias l="ls -1"
alias q="exit"
alias quit="exit"
alias vz="vim ~/.zshrc"
alias zr="source ~/.zshrc"
alias vr="vim ~/.vim/vimrc"
alias vb="vim ~/.vim/vimrc.bundles"

# --- Git ---
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gr="git reset"
alias gb="git branch"
alias gbc="git checkout -b"
alias gco="git checkout"
alias gd="git diff"
alias gm="git merge"
alias gp="git push"
alias gl="git pull"

# ----- PyPE  ----- #
alias dj="python manage.py"
alias djrs="python manage.py runserver"
alias djrss="python manage.py runsslserver"
alias djsh="python manage.py shell"
alias djsu="python manage.py createsuperuser"
alias djm="python manage.py migrate"
alias djmm="python manage.py makemigrations"

# ----- Misc ----- #
# 10ms for key sequences
KEYTIMEOUT=1

