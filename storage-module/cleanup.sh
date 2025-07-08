#!/bin/bash

# Script de nettoyage du module storage
set -e

echo "Nettoyage de l'infrastructure Terraform"

cd examples/

echo "ATTENTION: Ceci va supprimer TOUTES les ressources créées!"
echo "Êtes-vous sûr de vouloir continuer? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Suppression en cours..."
    terraform destroy
    echo "Nettoyage terminé!"
else
    echo "Nettoyage annulé"
fi
