if [ $# -lt 1 ]; then
    echo "Erreur : vous devez spécifier une action (N, S, L, D, A)."
    echo "Usage: $0 <action> [nom_machine]"
    exit 1
fi

ACTION=$1
VM_NAME=$2

if [ "$ACTION" = "N" ]; then
    if [ -z "$VM_NAME" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'N'."
        exit 1
    fi
    
    VBoxManage showvminfo "$VM_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        VBoxManage unregistervm "$VM_NAME" --delete
    fi

    VBoxManage createvm --name "$VM_NAME" --ostype "Debian_64" --register
    VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi" --size 64000 --format VDI
    VBoxManage modifyvm "$VM_NAME" --memory 4096 --nic1 nat --boot1 net
    VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"
    echo "La machine virtuelle '$VM_NAME' a été créée avec succès."

elif [ "$ACTION" = "S" ]; then
    if [ -z "$VM_NAME" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'S'."
        exit 1
    fi
    
    if ! VBoxManage showvminfo "$VM_NAME" > /dev/null 2>&1; then
        echo "Erreur : La machine '$VM_NAME' n'existe pas."
        exit 1
    fi
    
    VBoxManage unregistervm "$VM_NAME" --delete
    echo "La machine virtuelle '$VM_NAME' a été supprimée."

elif [ "$ACTION" = "L" ]; then
    VBoxManage list vms

elif [ "$ACTION" = "D" ]; then
    if [ -z "$VM_NAME" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'D'."
        exit 1
    fi
    VBoxManage startvm "$VM_NAME" --type headless

elif [ "$ACTION" = "A" ]; then
    if [ -z "$VM_NAME" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'A'."
        exit 1
    fi
    VBoxManage controlvm "$VM_NAME" poweroff

else
    echo "Erreur : Action '$ACTION' non reconnue."
    echo "Usage: $0 <action> [nom_machine]"
    exit 1
fi
