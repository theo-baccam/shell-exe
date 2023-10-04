path=$(echo $0 | rev | cut -b 17- | rev)
modifsave=$(cat $path/modifsave)
lastmodif=$(stat $path/Shell_Userlist.csv)
if [[ $modifsave -ne $lastmodif ]]; then
	while IFS="," read -r id prenom nom mdp role
	do
		username=$(echo $prenom.$nom | tr '[:upper:]' '[:lower:]')
		nrole=$(echo $role | tr -d '\r' | cat -t)
		sudo useradd $username 
		echo "$username:$mdp" | sudo chpasswd
		if [ $nrole = Admin ]; then
			sudo usermod -aG sudo $username
		else
			sudo usermod -aG users $username
		fi
	done < <(tail -n +2 Shell_Userlist.csv | tr -d " " && echo "")
	stat -c=%y Shell_Userlist.csv > modifsave
else
	echo "all good!"
fi
