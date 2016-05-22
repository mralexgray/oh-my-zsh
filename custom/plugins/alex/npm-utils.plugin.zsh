


npm-upgrade-global(){
	# SAVE=$IFS
	# IFS='
# '
  z=0
  for x in ${$(npm   outdated):1}; {
    PACK=$(echo "$z $x" | cut -f2 -d ' ')
      npm install -g $PACK@latest
      (( z++ ))
  }
  # IFS=$SAVE
}
