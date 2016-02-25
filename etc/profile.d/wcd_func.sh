# do ". wcd_func.sh"
# wcd_func 0.0.5, 2015-10-08
# Andreas Kirschner

post_command=cd_func

input="${@}"

help(){
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
}

wcd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

	input="${@}"

  if [[ $1 ==  "-h" ]]; then
	help;
  fi

	echo $input
	win_path=`cygpath -u "${input}"`
	echo ${win_path}
	${post_command} "${win_path}"
	return 0
}

alias wcd=wcd_func



