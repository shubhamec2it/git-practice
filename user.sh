read -p "Enter your user name: " usr_nm
read -p "Enter your user pswd: " usr_pswd
s_nm=`cat user.txt |grep -wi anup |cut -f1 -d "|"`
s_pswd=`cat user.txt |grep -wi anup |cut -f 2 -d "|"`

if [[ $usr_nm == $s_nm ]] && [[ $usr_pswd == $s_pswd ]]
then
	echo ""
	echo ""
	echo "Login Successful"
		ls -ltr
else
	echo ""
	echo ""
	echo "Login failed"
fi
	./user.sh
