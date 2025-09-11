# On vérifie qu'au moins une action a été spécifiée
if [ $# -lt 1 ]; then
    echo "Erreur : vous devez indiquer une action (N, S, L, D, A)."
    echo "Utilisation : $0 <action> [nom_machine]"
    exit 1
fi

ACTION=$1
NOM_MACHINE=$2

# Si l'action est de Créer une nouvelle machine (N)
if [ "$ACTION" = "N" ]; then
    if [ -z "$NOM_MACHINE" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'N'."
        exit 1
    fi
    
    # On vérifie si la machine existe déjà
    VBoxManage showvminfo "$NOM_MACHINE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Erreur : une machine nommée '$NOM_MACHINE' existe déjà. Pour la supprimer : \"$0 S [nom_machine]\""
        exit 1
    fi

    # Création de la machine et configuration de base
    VBoxManage createvm --name "$NOM_MACHINE" --ostype "Debian_64" --register
    VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$NOM_MACHINE/$NOM_MACHINE.vdi" --size 64000 --format VDI
    VBoxManage modifyvm "$NOM_MACHINE" --memory 4096 --nic1 nat --boot1 net
    VBoxManage storagectl "$NOM_MACHINE" --name "ControleurSATA" --add sata --controller IntelAhci
    VBoxManage storageattach "$NOM_MACHINE" --storagectl "ControleurSATA" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$NOM_MACHINE/$NOM_MACHINE.vdi"
    
    # Ajout des informations de création
    DATE_CREATION=$(date +"%Y-%m-%d_%H:%M:%S")
    UTILISATEUR=$USER
    VBoxManage setextradata "$NOM_MACHINE" "date_creation" "$DATE_CREATION"
    VBoxManage setextradata "$NOM_MACHINE" "utilisateur_creation" "$UTILISATEUR"

    echo "La machine virtuelle '$NOM_MACHINE' a été créée avec succès."

# Si l'action est de Supprimer une machine (S)
elif [ "$ACTION" = "S" ]; then
    if [ -z "$NOM_MACHINE" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'S'."
        exit 1
    fi
    
    # On vérifie si la machine existe
    if ! VBoxManage showvminfo "$NOM_MACHINE" > /dev/null 2>&1; then
        echo "Erreur : La machine '$NOM_MACHINE' n'existe pas."
        exit 1
    fi
    
    VBoxManage unregistervm "$NOM_MACHINE" --delete
    echo "La machine virtuelle '$NOM_MACHINE' a été supprimée."

# Si l'action est de Lister les machines (L)
elif [ "$ACTION" = "L" ]; then
    echo "Voici la liste des machines virtuelles :"
    VBoxManage list vms | while read -r line; do
        NOM_MACHINE_LISTE=$(echo "$line" | cut -d'"' -f2)
        
        # On récupère les informations supplémentaires
        DATE_CREATION=$(VBoxManage getextradata "$NOM_MACHINE_LISTE" "date_creation" | cut -d' ' -f2)
        UTILISATEUR_CREATION=$(VBoxManage getextradata "$NOM_MACHINE_LISTE" "utilisateur_creation" | cut -d' ' -f2)
        
        # On affiche le tout de manière claire
        echo "  - $NOM_MACHINE_LISTE"
        if [ ! -z "$DATE_CREATION" ]; then
            echo "    > Date de création : $DATE_CREATION"
        fi
        if [ ! -z "$UTILISATEUR_CREATION" ]; then
            echo "    > Utilisateur : $UTILISATEUR_CREATION"
        fi
        echo ""
    done

# Si l'action est de Démarrer une machine (D)
elif [ "$ACTION" = "D" ]; then
    if [ -z "$NOM_MACHINE" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'D'."
        exit 1
    fi
    VBoxManage startvm "$NOM_MACHINE" --type headless

# Si l'action est d'Arrêter une machine (A)
elif [ "$ACTION" = "A" ]; then
    if [ -z "$NOM_MACHINE" ]; then
        echo "Erreur : Le nom de la machine est manquant pour l'action 'A'."
        exit 1
    fi
    VBoxManage controlvm "$NOM_MACHINE" poweroff

# Si l'action n'est pas reconnue
else
    echo "Erreur : L'action '$ACTION' n'est pas reconnue."
    echo "Utilisation : $0 <action> [nom_machine]"
    exit 1
fi
