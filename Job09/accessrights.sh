# Le chemin vers le répertoire contenant le script et ses fichiers
path=$(echo $0 | rev | cut -c 17- | rev)

# Créer modifsave si il n'existe pas
if [[ ! -f "$path/modifsave" ]]; then
	touch $path/modifsave
fi

modifsave=$(cat $path/modifsave)
lastmodif=$(date -r Shell_Userlist.csv +%d-%m-%y-%H:%M)

if [[ "$modifsave" != "$lastmodif" ]]; then
	while IFS="," read -r id prenom nom mdp role
	do
		username=$(echo "$prenom.$nom" | tr '[:upper:]' '[:lower:]')
		if [ $(echo $username | wc -m) -lt 3 ]; then
			break
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
	echo $lastmodif > $path/modifsave
fi
