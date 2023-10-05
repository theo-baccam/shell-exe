# Le chemin vers le répertoire contenant le script et ses fichiers
path=$(echo $0 | rev | cut -c 17- | rev)

# Créer modifsave si il n'existe pas
if [[ ! -f "$path/modifsave" ]]; then
	touch $path/modifsave
fi

# modifsave et lastmodif permettent de voir si le fichier fût modifié
# récemment. 
modifsave=$(cat $path/modifsave)
lastmodif=$(date -r Shell_Userlist.csv +%d-%m-%y-%H:%M)

if [[ "$modifsave" != "$lastmodif" ]]; then
	# IFS permet de séparer les différents informations par colonne.
	while IFS="," read -r id prenom nom mdp role
	do
		# tr met l'username complétement en miniscule
		username=$(echo "$prenom.$nom" | tr '[:upper:]' '[:lower:]')
		# Sans refuser les usernames trop courts, le script va
		# tenter de créer un utilisateur "."
		if [ $(echo $username | wc -m) -lt 3 ]; then
			break
		fi
		# Enlève le caractère invisible ^M, qui marque qu'il faut
		# aller à la ligne, car sinon on ne pourra pas correctement
		# assigner des rôles.
		nrole=$(echo $role | tr -d '\r' | cat -t)
		sudo useradd $username 
		echo "$username:$mdp" | sudo chpasswd
		if [ $nrole = "Admin" ]; then
			sudo usermod -aG sudo $username
		else
			sudo usermod -aG users $username
		fi
	# Permet de lire la liste en ignorant la première ligne, en enlevant
	# les espaces, et en allant à la ligne après avoir affiché sinon
	# la dernière ligne n'est pas lu.
	done < <(tail -n +2 $path/Shell_Userlist.csv | tr -d " " && echo "")
	# Met la date de la modification dans modifsave
	echo $lastmodif > $path/modifsave
fi
