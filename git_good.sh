#!/bin/bash
# Copyright 2022 Jack Jorgensen
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

version="0.0.3"

# Clear the terminal
clear

# Catch errors and show usage text
trap "usage" TERM HUP INT
set -e

# Help text
usage() {
cat <<EOF
Useage:
  To declare the filename -f | --file filename
  To declare the commit message -c | --commit | -m 'My message'
  Unstage a file -u | --unstage filename
  Create a branch wizard -b |--branch
  Setup an entire repo structure -B | --build
  See commit history -C | --commits
  Push and pull commits -p | --sync
  Merge helper -M | --merge
  Update -U | --update
EOF
}

divider() {
  echo ""
  printf -- '-%.0s' {1..60}
  echo ""
}

# Create a new branch and check the branch out
create_branch() {
  divider
  printf "Creating new branch from current\n"
  read -p "Branch name: " BRANCHNAME

  CURRENT=$(git rev-parse --abbrev-ref HEAD)
  echo -e "Current Branch: \e[32m$CURRENT\e[0m"
  echo -e "Creating branch: \e[32m$BRANCHNAME\e[0m"
  echo -e "This action will create and checkout \e[31m$BRANCHNAME\e[0m"
  yn_prompt
  git checkout -b $BRANCHNAME

  CURRENT=$(git rev-parse --abbrev-ref HEAD)
  divider
  printf "Now working on $CURRENT"
  divider
}

merge() {
  divider
cat <<EOF
Preparing merge...

WARNING PLEASE ENSURE YOUR SOURCE AND DESTINATION BRANCHES ARE FULLY COMMITED
EOF
  yn_prompt
  git branch
  read -p "Source Branch: " SRCB
  read -p "Destination Branch: " DESB
  echo -e "Preparing to merge \e[32m$SRCB\e[0m onto branch \e[32m$DESB\e[0m"
  yn_prompt
  git checkout $DESB
  git merge $SRCB

}

# Ensure .gitignore includes this file
gitignore() {
  if [ -f ".gitignore" ];
    then
     if grep -Fxq "git_good.sh" .gitignore
      then
        echo ""
      else
        echo "Adding git_good.sh to gitignore"
        printf "\n#ignore git_good.sh\n" >> .gitignore
        echo "git_good.sh" >> .gitignore
        divider
        printf ".gitignore file has been updated to include git_good.sh"
        divider
      fi
    else

      printf "\n#ignore git_good.sh\n" > .gitignore
      echo "git_good.sh" >> .gitignore
      git add .gitignore
      divider
      printf ".gitignore file has been created and includes git_good.sh"
      divider

  fi
}

# Manage yes no prompts
yn_prompt() {
  echo ""
  while true; do
    read -p "Do you wish to proceed? (y/n) " yn
    case $yn in
      [yY] ) echo "Proceeding...";
              break;;
      [nN] ) echo -e "\e[31mHalting...\e[0m";
               exit;;
      * ) echo "Invalid input";;
    esac
  done
}

# Build a repo basic structure
build_repo(){
cat <<EOF
This action will generate the basic structure of a repo. 
For this the main branch should be checked out.
This process will generate a develop branch and push it to remote.
Create a standard UiPath gitignore. (note any current gitignore will be overridden)
EOF
yn_prompt

MAIN=$(git rev-parse --abbrev-ref HEAD)

cat <<EOF > .gitignore
# Local settings and cache
.settings/
.local/
.objects/

#ignore git_good.sh
git_good.sh
EOF

git add .gitignore && git commit -m "git good - Add standard UiPath gitignore"
git checkout -b develop
git push --set-upstream origin develop
git checkout $MAIN
git push
}

# Print files to be commited
files_to_commit(){
  printf "Added $1\n\nFiles ready to be commited\n"
  git status --short | grep '^[MARCD]'
  printf '\n'
}

# Add a file to the commit
add_file() {
  printf "Adding $1\n"
  git add "$1"
  files_to_commit
}

# Add a commit message
add_commit() {
  files_to_commit
  printf "Commit Message: $1\n\n"
  yn_prompt
  git commit -m "$1"
}

# Unstage a file (added but not commited)
unstage(){
  printf "Unstage file: $1"
  yn_prompt
  git reset HEAD "$1"
}

# Sync using pull push
sync() {
git fetch origin
git status
cat <<EOF

Above is the status of local against origin.
Please ensure you have commited your changes and are ready to push.

EOF
yn_prompt
git pull --rebase
yn_prompt
git push
}

# git_good config
config() {

  if [ ! -f ~/.gitgood.ini ]; then
    srcdir=$(pwd)
    printf "gitdir=$srcdir" > ~/.gitgood.ini
    fi
source <(grep = ~/.gitgood.ini)
}

# Update git good to latest
update(){
  present=$PWD
  cd $gitdir
  git pull
  cd $present
  cp $gitdir/git_good.sh git_good.sh
  echo "Complete"
}


# Print banner
banner(){
cat <<EOF

  #####  ### #######     #####  ####### ####### ######  
 #     #  #     #       #     # #     # #     # #     # 
 #        #     #       #       #     # #     # #     # 
 #  ####  #     #       #  #### #     # #     # #     # 
 #     #  #     #       #     # #     # #     # #     # 
 #     #  #     #       #     # #     # #     # #     # 
  #####  ###    #        #####  ####### ####### ######

EOF
echo "V$version"
echo ""
echo "Status of Repo: "
git status -s
divider
printf "\nBranches:\n"
git branch
divider
}

banner
config
gitignore


# Parse args
while [ "$1" != "" ]; do

  case "$1" in

    -B | --build)
      build_repo
      ;;

    -b | --branch)
      create_branch
      ;;

    -C | -commits)
      shift
      echo "Commit History"
      git log --graph --decorate --oneline
      ;;

    -f | --file)
      shift
      add_file "$1"
      ;;

    -c | --commit | -m)
      shift

      add_commit "$1"
      ;;

    -u | --unstage)
      shift
      unstage "$1"
      ;;

    -h | --help)
      usage
      exit
      ;;

    -p | --sync)
      sync

      ;;

    -U | --update)
      update
      ;;

    -M | --merge)
      merge
      exit
      ;;


    *) 
      usage
      exit

  esac

  shift
done