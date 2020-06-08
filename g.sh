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
alias gp='git pull'

# CD to the top level root of a git repository
alias gt='cd $(git rev-parse --show-toplevel)'

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


alias gcv='python '${PATH_TO_G}/checkout_version.py

##############################
###### Arc aliases ###########
##############################

alias l='arc lint'
alias f='git commit --allow-empty -m "PREDIFF_PLACEHOLDER"; arc diff'
alias nd='arc land'

##############################
###### Python aliases ########
##############################

alias p='python'
alias pm='python -m'
alias pt='python -m pytest'
alias pp='python -m json.tool'
alias u='pip install --upgrade'

##############################
###### S3 aliases ############
##############################

alias sl='s3cmd ls'
alias sg='s3cmd get'

##############################
###### Kubectl Aliases #######
##############################

alias k='kubectl -n'

##############################
###### Pipenv Aliases ########
##############################

alias pe='pipenv'
alias pl='pipenv lock'
alias psl='pipenv install --skip-lock'


##############################
###### Jsonnet aliases #######
##############################

alias jf="jsonnet fmt --comment-style s --string-style d -i"

##############################
###### Docker aliases ########
##############################

alias dd="docker"
alias cm="docker-compose"

##############################
###### Bash aliases ##########
##############################

alias l="ls -la"
alias c="clear"

function up() {
  cd $(printf "%.s../" $(seq 1 $1));
}

##############################
### Docker service aliases ###
##############################

# Start common services using docker and expose default ports
alias start_postgres="docker run -p 5432:5432 --name some-postgres -e POSTGRES_PASSWORD=password -d postgres"
alias start_redis="docker run -p 6379:6379 --name some-redis -d redis"
alias start_rmq="docker run -p 5672:5672 -p 15672:15672 -d --hostname my-rabbit --name some-rabbit rabbitmq:3-management"
alias start_es="docker run -p 9200:9200 -p 9300:9300 -e \"discovery.type=single-node\" -d docker.elastic.co/elasticsearch/elasticsearch:6.8.9"

function start_kafka {
    docker network create kafka-net --driver bridge
    docker run -d --name some-zookeeper -p 2181:2181 --network kafka-net -e ALLOW_ANONYMOUS_LOGIN=yes bitnami/zookeeper:latest
    docker run -d --name \
	   kafka-server1 --network kafka-net -e ALLOW_PLAINTEXT_LISTENER=yes \
	   -e KAFKA_CFG_ZOOKEEPER_CONNECT=some-zookeeper:2181 \
	   -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
	   -p 9092:9092 bitnami/kafka:latest
}

# To use this, run "BOOTSTRAP_URL=.... start_akhq"
# and visit localhost:8080 in the browser
alias start_akhq="docker-compose -f $PATH_TO_G/akhq.yaml up -d"
