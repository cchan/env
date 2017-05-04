#!/bin/bash
# .bashrc
# LastUpdated 6/29/2016 (the Git history of https://github.com/cchan/misc/blob/master/bashrc/.bashrc is more reliable)
# Copyright Clive Chan, 2014-present (http://clive.io)
# License: CC BY-SA 4.0(https://creativecommons.org/licenses/by-sa/4.0/)

# Written for Windows (10), also works on Linux (Amazon AMI, RedHat Enterprise), also works on ksh.
# Description: Sets up a convenient Git Bash environment. Copy into ~ (C:/Users/You/), and run msysgit (or just ssh into your ec2 instance)

# Development note: I should read and use http://www.tldp.org/LDP/abs/html/abs-guide.html


# https://www.linuxquestions.org/questions/linux-newbie-8/scp-copy-a-file-from-local-machine-to-remote-machine-214150/
# "dumb" terminal type for SCP doesn't support "clear" and other things
test "dumb" == $TERM && return


####### CUSTOMIZABLES #######

# Other Tips:

# use .ssh/config
#     host asdf
#     hostname 123.456.78.90
#     port 22
#     user fdsa
# then you can just type "ssh asdf" and it'll work


# Paths
gitpath=~/github
gitbashrc=$gitpath/misc/bashrc
sshtmp=/tmp/sshagentthing.sh #yes, this is correct. It's a special Unix directory.


# Python
alias py="python -u"

# Go
export GOPATH=~/.go

# Editor aliases
npppath='C:\Program Files (x86)\Notepad++\notepad++.exe'
if [ -f "$npppath" ]; then
  alias edit="'$npppath'"
  alias npp="'$npppath'"
  if ! command -v nano >/dev/null; then
    alias nano="'$npppath'";
  fi
elif command -v nano >/dev/null; then
  alias edit=nano
  alias npp=nano
fi
# alias robotc="\"C:\Program Files (x86)\Robomatter Inc\ROBOTC Development Environment 4.X\RobotC.exe\""
# alias sublime="\"C:\Program Files\Sublime Text 3\sublime_text.exe\""


####### CODE #######

# COLORS!
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# Regular Colors
export Black='\e[0;30m'        # Black
export Red='\e[0;31m'          # Red
export Green='\e[0;32m'        # Green
export Yellow='\e[0;33m'       # Yellow
export Blue='\e[0;34m'         # Blue
export Purple='\e[0;35m'       # Purple
export Cyan='\e[0;36m'         # Cyan
export White='\e[0;37m'        # White

# Bold
export BBlack='\e[1;30m'       # Black
export BRed='\e[1;31m'         # Red
export BGreen='\e[1;32m'       # Green
export BYellow='\e[1;33m'      # Yellow
export BBlue='\e[1;34m'        # Blue
export BPurple='\e[1;35m'      # Purple
export BCyan='\e[1;36m'        # Cyan
export BWhite='\e[1;37m'       # White

export ColorReset='\e[00m'     # Reset to default


# Title + Version
# echo -e "\e[38;5;242mGit Bash"
# git version
# echo


# Gets to the right place
cd $gitpath


# Self-update.
if [ -f $gitbashrc/.bashrc ]; then
	cmp --silent $gitbashrc/.bashrc ~/.bashrc
	if [ $? -eq 0 ]; then
		: # echo ".bashrc is up to date."
	elif [ $? -eq 1 ]; then
		cp -v $gitbashrc/.bashrc ~/.bashrc
		echo "Self-updated. Restarting bash...";
		exec bash -l
	else
		echo "Error comparing with new version. (???)"
	fi
else
	echo "Error looking for new version. Your \$gitbashrc path ($gitbashrc) may not be correct, and you may need to update \~/.bashrc manually."
fi


# Makes me sign in with SSH key if necessary; tries to preserve sessions if possible.
# NOTE THAT this agent feature must be disabled to have security. Any application can ask the ssh-agent for stuff.
	# Actually, this may not be true. :/
# For a guide on how to use SSH with GitHub, try https://help.github.com/articles/generating-ssh-keys/
# If something messes up, ssh-reset to remove the starter file and restart the shell.
# "ssh-agent" returns a bash script that sets global variables, so I store it into a tmp file auto-erased at each reboot.
if [ -f ~/.ssh/id_rsa ] || [ -f ~/.ssh/id_ecdsa ]; then # Only if we actually have some SSH stuff to do
	ssh_start () { ssh-agent > $sshtmp; . $sshtmp > /dev/null; ssh-add &> /dev/null; echo PID $SSH_AGENT_PID; } # -t 1200 may be added to ssh-agent.
  alias ssh-start=ssh_start
	ssh_end () { rm $sshtmp; kill $SSH_AGENT_PID; }
  alias ssh-end=ssh_end
	ssh_reset () { echo -n "Resetting SSH agent... "; ssh_end; ssh_start; }
  alias ssh-reset=ssh_reset
	if [ ! -f $sshtmp ]; then # Only do it if daemon doesn't already exist
		echo
		echo "New SSH agent"
		ssh_start
	else # Otherwise, everything is preserved until the ssh-agent process is stopped.
		# echo "Reauthenticating SSH agent..."
		. $sshtmp > /dev/null
		if ! ps -e | grep $SSH_AGENT_PID > /dev/null; then
			echo -n "No agent with PID $SSH_AGENT_PID is running. "
			ssh_reset
		fi
	fi
else
	echo SSH is not currently set up. You might want to do that.
fi


# Git shortforms.
GIT_PAGER=less
type hub >/dev/null 2>&1 && alias git=hub
alias bfg="java -jar $gitbashrc/bfg-1.12.12.jar"
alias ga="git add --all :/"
alias gs="git status" # Laziness.
alias gc="git add --all :/ && git commit" # Stages everything and commits it. You can add -m "asdf" if you want, and it'll apply to "git commit".
alias gd="git diff"
alias gl="git log"
gu () { gc "$@" && git push; } # commits things and pushes them. You can use gu -m "asdf", since all arguments to gu are passed to gc.
alias gam="gc --amend --no-edit && git push --force" # Shortform for when you mess up and don't want an extra commit in the history
gmir () { git fetch origin && git reset --hard $(git rev-parse --abbrev-ref --symbolic-full-name @{u}); } # git pull --force
grp () { br=`git branch | grep "*" | cut -c 3-`; git remote add $1 "git@github.com:$2"; git fetch $1; git push -u $1 $br; } # git remote add and push

# Other shortforms
alias grep='grep --color --exclude-dir=.git --exclude-dir=node_modules'

# Shortform SSH cloning from GitHub and BitBucket
# Use like this: clone-gh cchan/misc
clone_gh () { git clone "git@github.com:$1"; }
alias clone-gh=clone_gh
gh_clone () { clone-gh $1; }
alias gh-clone=gh_clone
clone_bb () { git clone "git@bitbucket.org:$1"; }
alias clone-bb=clone_bb
bb_clone () { clone-bb $1; }
alias bb-clone=bb_clone


# The amazing git-status-all script, which reports on the status of every repo in the current folder.
# NOTE: `find` used in this way does not work with find v4.4.2 for some reason.
#   It does not fork the exported function, and find -name seems to hang.
#   Lesson learned: always APPEND to $PATH unless you know what you're doing.
#   [the culprit was ruby devkit with the extremely outdated tools]
gsa () {
	typeset -xf gsa_repodetails
	find -type d -name .git -prune -exec bash -c 'gsa_repodetails "$0"' {} \;
}
gsa_repodetails () {
	cd "$1/..";
	echo "
--------$1--------";
	git remote update >/dev/null &>/dev/null
	git -c color.status=always rev-parse --abbrev-ref HEAD --
	git -c color.status=always status -s
	
	for branch in $(git for-each-ref --sort="-authordate:iso8601" --format="%(refname)" refs/heads/); do
		SHORT=$(basename "$branch")
		
		echo -e -n $BCyan"$SHORT: "$ColorReset
		if [[ -n $(git config --get branch.$SHORT.remote) ]]; then
			LOCAL=$(git rev-parse "$SHORT")
			REMOTE=$(git rev-parse "$SHORT"@{upstream})
			BASE=$(git merge-base "$SHORT" "$SHORT"@{upstream})
			
			if [ $LOCAL = $REMOTE ]; then
				echo -e $BGreen"Up-to-date."$ColorReset
				git log -1 --pretty=format:"LATEST: %ar	%<(50,trunc)%s" $LOCAL --
			elif [ $LOCAL = $BASE ]; then
				echo -e $BRed"Need to pull!"$ColorReset
				git log -1 --pretty=format:"LOCAL: %ar	%<(50,trunc)%s" $LOCAL --
				git log -1 --pretty=format:"REMOTE: %ar	%<(50,trunc)%s" $REMOTE --
			elif [ $REMOTE = $BASE ]; then
				echo -e $BRed"Need to push!"$ColorReset
				git log -1 --pretty=format:"LOCAL: %ar	%<(50,trunc)%s" $LOCAL --
				git log -1 --pretty=format:"REMOTE: %ar	%<(50,trunc)%s" $REMOTE --
			else
				echo -e $BRed"Diverged!!"$ColorReset
				git log -1 --pretty=format:"LOCAL: %ar	%<(50,trunc)%s" $LOCAL --
				git log -1 --pretty=format:"REMOTE: %ar	%<(50,trunc)%s" $REMOTE --
				git log -1 --pretty=format:"MERGE-BASE: %ar	%<(50,trunc)%s" $BASE --
			fi
		else
			echo -e $BYellow"No upstream configured."$ColorReset
			git log -1 --pretty=format:"LATEST: %ar	%<(50,trunc)%s" $SHORT --
		fi
	done

}


# Derived from http://stackoverflow.com/a/24584976/1181387
git_cdc () {
  commit="$1" datecal="$2"

  if [ -z "$commit" ] || [ -z "$datecal" ]; then
    echo Format: git-cdc {commit} {date}
    return 1
  fi

  temp_branch="temp-rebasing-branch"
  current_branch="$(git rev-parse --abbrev-ref HEAD)"

  if [ -z "$current_branch" ]; then
    return 1
  fi

  date_timestamp=$(date -d "$datecal" +%s)
  date_r=$(date -R -d "$datecal")

  git checkout -b "$temp_branch" "$commit"
  GIT_COMMITTER_DATE="$date_timestamp" GIT_AUTHOR_DATE="$date_timestamp" git commit --amend --no-edit --date "$date_r"
  git checkout "$current_branch"
  git rebase  --autostash --committer-date-is-author-date "$commit" --onto "$temp_branch"
  git branch -d "$temp_branch"
  git log "$commit" -n 1 --date=iso --pretty=fuller
}
alias git-cdc=git_cdc

# Line-counter. Just run "lines" and it'll descend into all Git repos under it.
lines_each () {
  cd "$1/.."
  echo -n "$1" | sed 's/..\(.*\)...../\1/'
  echo -n ": "
  git ls-files | awk '!/min\.js|min\.css|jpeg|jpg|JPG|png|jar/' | xargs cat 2>/dev/null | wc -l
}
lines () {
  typeset -xf lines_each
  find -type d -name .git -prune -exec bash -c 'lines_each "$0"' {} \;
}



# https://askubuntu.com/questions/249174/prepend-current-git-branch-in-terminal
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
PS1="\[$Yellow\][\$?] " # Exit status for the last command
PS1+="\[$BBlue\]\\u@\\h " # User@Host
PS1+="\[$Purple\]\w\[\e[m\] " # Path
PS1+="\[$Cyan\]\$(parse_git_branch)" # Git branch if applicable
PS1+="\[$Cyan\]\$\[\e[m\] " # Prompt
PS1+="\[$BWhite\]" # User input color
PS1+="\033]0;${USERNAME}@${HOSTNAME}: ${PWD}\007" # Set title bar
PROMPT_COMMAND="history -a;history -c;history -r;" # https://superuser.com/questions/555310/bash-save-history-without-exit

if ! command -v gpg >/dev/null; then
  echo 'GPG is not installed.'
else
  gpgoutput=$(gpg --check-sigs)
  if [ $? != 0 ]; then
    echo 'ERROR verifying GPG keyring signatures!'
    echo $gpgoutput
  else
    echo 'GPG keyring verified. Remember to `gpg --refresh-keys` and watch for updates.'
  fi
fi


if [ -e ~/.bashrcrc ]; then
  . ~/.bashrcrc 2>/dev/null
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm



# Last, to avoid interfering with the automated stuff
# "Avoid Losing Files" - cs137
alias cp="cp -i"
alias mv="mv -i"
# alias rm="rm -i"

if [ -n "$DEBUG" ]; then
  echo "[debug] FINISHED!"
fi
