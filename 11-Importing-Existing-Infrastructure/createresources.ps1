az group create --name rg-terraform-import --location eastus

az network vnet create \
  --name vnet-terraform-eastus-1 \
  --resource-group rg-terraform-import \
  --address-prefix 10.0.0.0/16 \
  --subnet-name subnet-terraform-10.0.0.0_24 \
  --subnet-prefix 10.0.0.0/24

az network nsg create -g rg-terraform-import -n nsg-terraform

az network nsg rule create -g rg-terraform-import --nsg-name nsg-terraform -n Allow-HTTPS --priority 100 \
    --source-address-prefixes '*' --source-port-ranges 443 \
    --destination-address-prefixes '*' --destination-port-ranges 443 --access Allow \
    --protocol Tcp --description "Allow HTTPS"

az network nsg rule create -g rg-terraform-import --nsg-name nsg-terraform -n Allow-HTTP --priority 110 \
    --source-address-prefixes '*' --source-port-ranges 80 \
    --destination-address-prefixes '*' --destination-port-ranges 80 --access Allow \
    --protocol Tcp --description "Allow HTTP"

az network vnet subnet create -g rg-terraform-import --vnet-name vnet-terraform-eastus-1 \
    -n subnet-terraform-10.0.1.0_24 \
    --address-prefixes 10.0.1.0/24  \
    --network-security-group nsg-terraform