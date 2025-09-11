# SAE 52 : Piloter un projet informatique

Date : 11/09/2025  
Auteur : Mufti Louna - Ravalison Ventso

Ce rapport présente notre travail réalisé dans le carde de la SAE 52. Le but était d'automatiser la création de machine virtuelle avec certains paramètres à l'aide d'un script.  
Nous avons décidé d'utiliser un script shell bach sous linux.  
L'objectif était de remplacer les commandes longues et complexes de l'interface **VBoxManage** par un outil simple, facile à utiliser, qui permettrait à l'utilisateur de réaliser les opérations courantes (créer, démarrer, arrêter, supprimer et lister des VMs) avec une seule ligne de commande.

## 1) Guide d'utilisation

Le script est conçu pour être utilisé de manière simple depuis un terminal.  
Rendre le script exécutable en utilisant la commande `chmod +x genMV.sh`.  
Ensuite :

* **Créer une VM** : `./genMV.sh N <nom_de_la_vm>`
* **Supprimer une VM** : `./genMV.sh S <nom_de_la_vm>`
* **Lister les VMs** : `./genMV.sh L`
* **Démarrer une VM** : `./genMV.sh D <nom_de_la_vm>`
* **Arrêter une VM** : `./genMV.sh A <nom_de_la_vm>`


## 2) Développement du projet

Nous avons d'abord installé les outils de base nécessaires à la virtualisation (vbox debian), afin de commencer dans un environnement propre.
Nous avons commencé par tester chacun de notre coté les commandes VBoxmanage afin de comprendre leurs rôles. Par la suite, nous avons réalisé le script par étape en ajoutant les fonctionnalités les unes après les autres.  
Le cœur du développement a été la création de la logique conditionnelle pour chaque action :

* **L'option N (Créer une VM)** a nécessité une vérification préalable pour s'assurer que la machine n'existait pas déjà. Nous avons résolu ce problème en utilisant le code de retour de la commande `VBoxManage showvminfo`, en redirigeant sa sortie vers la "poubelle" (`> /dev/null 2>&1`) pour ne pas encombrer le terminal.
* **L'option S (Supprimer)** a suivi une logique similaire, en vérifiant si la machine existait avant de tenter de la supprimer, pour éviter une erreur.
* **Les options D, A, et L** ont été plus simples, car elles exécutent des commandes **VirtualBox** directes pour démarrer, arrêter et lister les machines.

## 3) Difficultés rencontrées et améliorations

Le changement de poste nous a forcé à nous adapter et a être organisé dans notre travail. Grace à l'utilisation de Git nous avions toujours la dernière version de notre travail disponible.

* **Conflits de virtualisation** : Nous avons pu rencontré des difficultés lors de l'installation de VirtualBox et dans la virtualisation dans la machine virtuelle.
L'activation de la technologie de virtualisation (**VT-x**) dans le BIOS de l'ordinateur était une étape nécessaire. Cependant, même après l'activation, des conflits ont persisté.

* **Compréhension des redirections** : Un autre défi technique a été de comprendre la redirection de la sortie standard et de l'erreur (`> /dev/null 2>&1`). Cette notation, était au départ difficile à saisir, mais son rôle a été essentiel pour le script.

En terme d'amélioration, il aurait été intéréssant de pouvoir créer plusieurs machines virtuelles en une exécution du programme.

## 3) Conclusion

Pour conclure, ce projet nous a permis de découvrir l'utilisation de VirtualBox via VBoxManage. Il nous a donné l'opportunité d'approfndir les notions du shell comme la gestion d'arguments et les interactions entre le script et l'OS.
