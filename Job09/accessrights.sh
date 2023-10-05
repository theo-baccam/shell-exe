path=$(echo $0 | cut -c -1)
modifsave=$(cat $path/modifsave)
lastmodif=$(stat -c=%y $path/Shell_Userlist.csv)
if [[ "$modifsave" != "$lastmodif" ]]; then
	while IFS="," read -r id prenom nom mdp role
	do
		username=$(echo "$prenom.$nom" | tr '[:upper:]' '[:lower:]')
		if [ $(echo $username | wc -m) -lt 3 ]; then
			exit 0
		fi
		nrole=$(echo $role | tr -d '\r' | cat -t)
		sudo useradd $username 
		echo "$username:$mdp" | sudo chpasswd
		if [ $nrole = "Admin" ]; then
			sudo usermod -aG sudo $username
		else
			sudo usermod -aG users $username
		fi
	done < <(tail -n +2 $path/Shell_Userlist.csv | tr -d " " && echo "")
	stat -c=%y $path/Shell_Userlist.csv > $path/modifsave
fi
