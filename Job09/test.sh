while IFS="," read -r id prenom nom mdp role
do
	username=$(echo $prenom.$nom | tr '[:upper:]' '[:lower:]')
	sudo useradd $username 
	echo "$username:$mdp" | sudo chpasswd
	if [ $role = Admin ]; then
		echo "admin!!"
	else
		echo "user!!!"
	fi
done < <(tail -n +2 Shell_Userlist.csv | tr -d " " && echo "")
