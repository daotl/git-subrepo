#!/bin/bash
###########################################################################
# Prepare your system for the work with this repository
###########################################################################

# ARGS array
ARGS=()

# append the first argument as it is
ARGS+=( "$1" )
shift

# make all other arguments relative to git root
GIT_ROOT=$(git rev-parse --show-toplevel) || ( echo "Error: Please run this command within a git repository" && exit 1 )

while (( "$#" )); do
  case "$1" in
    .|..|./*|../*)
      # if an argument starts with "./" or "../": Make it relative to git root
      ARGS+=( "$(realpath --relative-to=$GIT_ROOT -m $1)" )
      shift
      ;;
    *)
      # All other arguments: Keep as they are
      ARGS+=( "$1" )
      shift
      ;;
  esac
done

(
	echo -e "\e[97mRunning: cd $GIT_ROOT && git subrepo ${ARGS[@]}\e[39m"
	cd $GIT_ROOT
	git subrepo ${ARGS[@]}
)

