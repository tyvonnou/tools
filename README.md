# Tools

## Installation 

1- Cloner le projet sur votre poste.

```bash
git clone --recurse-submodule <repo-URL>
```

2- Ajouter dans `~/.bashrc`, en modifiant le chemin si nécéssaire : 

```bash linenums="1" 
# Fonctions
if [ -f "${HOME}/Documents/git/tools/bash/home.sh" ]; then
   source "${HOME}/Documents/git/tools/bash/home.sh"
fi
```

## GCM - Git Commit Manager 

### Commande gcm
    
Format proposé : `OPERATION(OPTIONNEL:TICKET): Description`

Inspiré par la documentation [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

### Liste des opérations

- **BUILD** : Modifications qui affectent le système de build ou les dépendances externes -> *des changements dans les fichiers de configuration de construction*.
- **CHORE** : Tâches de maintenance qui ne modifient pas le code source ou n'ajoutent pas de fonctionnalités -> *des mises à jour de dépendances, des nettoyages de code*.
- **CI** : Modifications liées à l'intégration continue -> *mises à jour des fichiers de configuration CI/CD*.
- **DOCS** : Modifications ou ajouts à la documentation.
- **FEAT** : Ajout d'une nouvelle fonctionnalité au code.
- **FIX** : Correction d'un bogue dans le code.
- **PERF** : Améliorations de la performance du code.
- **REFRACTOR** : Refactorisation du code sans changer son comportement externe.
- **REVERT** :  Annulation d'un commit précédent.
- **TEST** : Ajout ou mise à jour de tests.
- **STYLE** : Changements qui ne touchent pas la logique du code mais améliorent le style ou la mise en forme.
- **WIP** : "Work In Progress", indique que le commit est un travail en cours et n'est pas encore terminé ou prêt.

### Commande gcm_fixup

La fonction gcm_fixup est utilisée pour créer un commit de type fixup dans un dépôt Git. Un commit de fixup est un commit qui corrige ou améliore le commit précédent. Cette fonction automatise le processus de création d'un commit fixup et de rebase interactif.

1. Vérifie s'il y a des modifications prêtes à être validées (staged).
2. Crée un commit fixup pour le dernier commit. 
3. Gère les modifications non indexées en les remettant temporairement (stash).
4. Effectue un rebase interactif pour combiner le commit fixup avec le commit précédent.
5. Récupère les modifications remises après le rebase.


### Graphe

* **gcm_log** : Affiche les commits sous forme condensée, avec des décorations et un graphe des branches.
* **gcm_log_all** : Affiche un log détaillé avec des sauts de ligne pour chaque commit, rendant l'affichage plus lisible.

## Raccourcis 

* **c.** : Ouvrir VSCodium / VSCode dans le répertoire courant.
* **e.** : Ouvrir l'explorer de fichier dans le répertoire courant.
* **g.** : Accéder à la page gitlab/github du répertoire courant. 
