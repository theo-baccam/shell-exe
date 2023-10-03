echo "scale=2; $1$2$3" | bc
# Problème avec *, qui est considéré comme une wildcard, donc il faut
# utiliser \*
