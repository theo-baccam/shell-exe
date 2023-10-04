path=$(echo $0 | rev | cut -b 17- | rev)
modifsave=$(cat $path/modifsave)
lastmodif=$(stat -c=%y $path/Shell_Userlist.csv)
if [[ "$modifsave" != "$lastmodif" ]]; then
	while IFS="," read -r id prenom nom mdp role
	do
		username=$(echo "$prenom.$nom" | tr '[:upper:]' '[:lower:]')
		nrole=$(echo $role | tr -d '\r' | cat -t)
		sudo useradd $username 
		echo "$username:$mdp" | sudo chpasswd
		if [ $nrole = "Admin" ]; then
			sudo usermod -aG sudo $username
			echo "did $username"
		else
			sudo usermod -aG users $username
			echo "did $username"
		fi
	done < <(tail -n +2 Shell_Userlist.csv | tr -d " " && echo "")
	stat -c=%y Shell_Userlist.csv > modifsave
fi
