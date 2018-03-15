# do ". acd_func.sh"
# acd_func 1.0.5, 10-nov-2004
# petar marinov, http:/geocities.com/h2428, this is public domain

init_file=${HOME}/.plan


cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "-h" ]]; then
    echo
    echo "cd_func is an advanced version to change directory"
    echo
    echo "usage: cd_func [<option>|dir]"
    echo "where 'dir' specifies a directory to change to or"
    echo "options are"
    echo "--"
    echo "    shows the directory stack"
    echo "-i"
    echo "    reinitializes the directory stack with the directories from"
    echo "    ${init_file}"
    echo "-d"
    echo "    deletes the directory stack"
    echo "-h"
    echo "    print this help"
    return 0
  fi

  if [[ $1 ==  "-i" ]]; then
		wd=$(pwd)
		cd_func -d
    for i in $(cat ${init_file}); do
      if [ -d $i ]; then
        cd_func $i > /dev/null;
      fi;
    done;
		cd_func ${wd}
    return 0
  fi

  if [[ $1 ==  "-d" ]]; then
    while popd -0 &>/dev/null; do true; done
#    cd_func -i
    return 0
  fi

  if [[ $1 ==  "--" ]]; then
		echo "Directory Stack:"
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir=${HOME}${the_new_dir:1}

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 31th entry
  popd -n +31 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 30; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2=${HOME}${x2:1}
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

alias cd=cd_func

if [ -e "${init_file}" ]; then
  IFS_TMP=${IFS}
  IFS=$'\n'
	currWd=`pwd`;
	for i in `cat ${init_file}`; do
		if [ -d "$i" ]; then
			cd "$i" > /dev/null;
		fi;
	done;
  IFS=${IFS_TMP}
	cd $currWd;
fi

if [[ $BASH_VERSION > "2.05a" ]]; then
  # ctrl+w shows the menu
	bind -x '"\ew"':"cd_func --" 2>/dev/null
#  bind -x '"\ew\":cd_func -- ;"
fi
