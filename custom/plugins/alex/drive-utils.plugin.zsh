
DRIVE=gdrive

drive-heirarchy () {

	ID="$1"; RES=0; SPACES=; echo -n "┌"

	while [[ $ID && $RES == 0 ]]; do
	  CMD="$($DRIVE info -i $ID)"
	  RES=$?
		OUT=$(echo "$CMD" | grep "Title:" | sed 's/Title://g')
		echo -n "$OUT"
		[[ $ID == $1 ]] && { printf "%s" "$CMD" | grep "Size:" | sed 's/Size://g' } || echo " ($ID)"
		echo -n "$SPACES"
		[[ ! "$OUT" =~ "My Drive" ]] && echo -n "└─┬" || echo "┴"
	  SPACES+="  "
		ID=$(echo "$CMD" | grep "Parents" | sed 's/Parents: //g')
	done
}


drive-search () {

	for x in $($DRIVE list -t "$1" --noheader); {
  	eval "words=($x)"
    drive-heirarchy "${words[1]}"
  }
}


drive-biggest(){
	[[ $# -ge 1 ]] && { echo finding $1; CT=( -m $1 ) }
	$DRIVE list --order "quotaBytesUsed desc" $CT
}

drive-move() {

  FOLDERNAME=
	for FOLDER in "$@"; {
		FOLDERNAME=${FOLDER:t}
    echo "FOLDERNAME is $FOLDERNAME  ..  creating .... "
    [[ "$FOLDERNAME" == "" ]] && echo "what folder" && exit 1
	  # Create directory on drive
    RES="$($DRIVE mkdir $FOLDERNAME)"
    if [[ $? == 0 ]]; {
	    echo "$RES"
    	#  Directory 0B3X9GlR6EmbnOEd6cEh6bU9XZWM created
    	eval "words=($RES)"
    	echo "ID is ${ID=${words[2]}}"
      if [[ $ID != "" ]]; {
      	# Sync to drive
      	$DRIVE sync upload "$FOLDER" $ID
        if [[ $? == 0 ]]; {
        	echo "Success.. moving $FOLDER to local drive."
        	# mv $FOLDER /gd
        }
      }
    }
  }
}


