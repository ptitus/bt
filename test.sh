if ! grep -q ^user: /etc/passwd
  then echo "File contains no occurrence of user."
  else echo "File contains at least one occurrence of user."  
fi

case "$HOSTNAME" in
	(xyz) 	echo "nö!";;
	(möter-TUXNB) echo "jay!"
		     echo "gefunden!";;
	(*)	echo "nix";;
esac


