#!/bin/bash

# Script de déploiement du module storage
set -e

echo "Déploiement du module Terraform Storage OpenStack"

# Vérifier les variables d'environnement OpenStack
if [ -z "$OS_AUTH_URL" ]; then
    echo "Erreur: Variable OS_AUTH_URL non définie"
    echo "Configurez vos credentials OpenStack d'abord:"
    echo "   export OS_AUTH_URL='https://your-openstack.com:5000/v3'"
    echo "   export OS_USERNAME='your-username'"
    echo "   export OS_PASSWORD='your-password'"
    echo "   # ... autres variables"
    exit 1
fi

echo "✅ Variables OpenStack détectées"

# Aller dans le répertoire examples
cd examples/

echo "Initialisation de Terraform..."
terraform init

echo "Planification du déploiement..."
terraform plan

echo "Voulez-vous continuer avec le déploiement? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Application de la configuration..."
    terraform apply
else
    echo "Déploiement annulé"
    exit 0
fi

echo "Déploiement terminé!"
echo "Pour voir les outputs:"
echo "   terraform output"
