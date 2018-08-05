# Bash source gives the relative path to this file. Get the directory
# from it, cd to the parent, and pwd to get the full path
PATH_TO_G="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


##############################
###### Git aliases ###########
##############################

alias g='git'
alias ga='git add'
alias go='git checkout'
alias gb='git branch'

# Since we are working on diff-level granularity, most of the time commit
# messages aren't used, so they can default to 'z'
alias gc='git commit -m "z"'

# We assume that there will be a single branch for each diff
# that is not [master]. Hence, it is faster to have default commands
# that reference [master]
alias gr='git rebase master'
alias grc='git rebase --continue'
alias gdms='git diff master --stat'
alias gdm='git diff master'

alias gd='git diff'
alias gds='git diff --stat'

# Don't show untracked files, helpful if you are making temp files/
# messing around. Also potentially bad because it can hide files
alias gs='git status -uno'


##############################
###### Diff aliases ##########
##############################

# G New: create a new diff. Checkout master first to make
# sure we don't run into issues
alias gn='go master; go -b'

# G switch: switch between two diffs. As a precaution, first check that
# there are no modified files in the current workspace. If there are, this
# command prints something like [modified: foo.txt] and exits
alias gsw='gs | grep "modified: " || go'

# G Diff Diff. Get the changeset between the current head and most recent
# commit that was diffed to arc. Note that this command makes a network request
# and so may take half a second or so. Also note that this method assumes your
# normal commits have message 'z'
alias gdd='python '${PATH_TO_G}/get_diff_changelog.py
# Git Status equivalent of the above command
alias gdds='python '${PATH_TO_G}/get_diff_changelog.py' status'

# G Shortlog. Command args are [from_commit, rel_path, to_commit]. [rel_path]
# is optional and defaults to ['.']. [to_commit] is optional and defaults to
# ['origin/master']
alias gsl='python '${PATH_TO_G}/shortlog.py

##############################
###### Arc aliases ###########
##############################

alias gl='arc lint'
alias gf='arc diff'
alias gnd='arc land'


##############################
###### Inenv aliases #########
##############################

alias i='inenv'
alias d='deactivate'

##############################
###### Coding aliases ########
##############################

alias p='python'
alias pt='python -m pytest'
alias pp='python -m json.tool'
