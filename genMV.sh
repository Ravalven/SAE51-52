#!/bin/bash

VM_NAME="Debian1"

RAM_SIZE="4096"

HDD_SIZE="64000"

OS_TYPE="Debian_64"

echo "Création de la machine virtuelle '$VM_NAME'..."
VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register

echo "Création du disque dur virtuel de ${HDD_SIZE} Mo..."
VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi" --size $HDD_SIZE --format VDI

echo "Configuration de la machine et attachement du disque..."
VBoxManage modifyvm "$VM_NAME" --memory $RAM_SIZE --nic1 nat --boot1 net
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"

read -p "La machine a été créée. Vérifiez-la dans la GUI de VirtualBox, puis appuyez sur ENTREE pour la supprimer..."

echo "Suppression de la machine virtuelle '$VM_NAME'..."
VBoxManage unregistervm "$VM_NAME" --delete

echo "Script terminé."
