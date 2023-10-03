# La date en format correct
date=$(date +%d-%m-%Y-%H:%M)

# Pour avoir un chemin variable, sans le nom du script
path=$(echo $0 | rev | cut -c 12- | rev)

# La raison que je grep en spécifiant 'tty' est car normalement ça compte 
# aussi les connections aux pseudo-terminals, qui sont par exemple utilisé par
# des émulateurs de terminal.
last $1 | grep tty | wc -l > $path/number_connection-$date
tar -cf $path/Backup/number_connection-$date.tar $path/number_connection-$date --force-local
