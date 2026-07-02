#!/bin/bash

##########################################################
#   Formatage des commits
##########################################################
function gcm() {
    # Définir les codes de couleur
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NC='\033[0m' # Pas de couleur

    # Récupérer le nom de la branche actuelle
    branch_name=$(git rev-parse --abbrev-ref HEAD)

    # Extraire le scope à partir du nom de la branche (tout ce qui est après le '/')
    if [[ "$branch_name" == *"/"* ]]; then
        scope=${branch_name#*/}
    else
        scope="" # Si pas de '/', définir scope comme vide
    fi

    echo "Select commit type:"
    types=("BUILD" "CHORE" "CI" "DOCS" "FEAT" "FIX" "PERF" "REFACTOR" "REVERT" "TEST" "STYLE" "WIP")

    for i in "${!types[@]}"; do
        echo -e "${RED}$((i + 1))${NC})\t${types[i]}"
    done

    read -p "Enter the number of your choice: " choice

    # Validation du choix
    if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#types[@]}" ]; then
        echo -e "${RED}Invalid choice${NC}"
        return
    fi

    type="${types[$((choice - 1))]}"

    if [ -n "$scope" ]; then
        read -p "Voulez-vous utiliser le scope actuel (actuel: '$scope') ? (y/n) : " remove_scope
        if [[ "$remove_scope" =~ "n" ]]; then
            read -p "Scope : " input_scope
            scope=$input_scope
        fi
    else
        read -p "Scope : " input_scope
        scope=$input_scope
    fi
    
    read -p "Description (leave empty to open an editor): " description
    if [ -z "$description" ]; then
        # Créer le message de commit en fonction de la présence de scope
        if [ -z "$scope" ]; then
            default_description="${type}: "
        else
            default_description="${type}(${scope}): "
        fi
        tempfile=$(mktemp)
        echo "$default_description" >"$tempfile"
        vim "$tempfile"
        # Lire le fichier et préparer les arguments pour git commit
        IFS=$'\n' read -d '' -r -a lines <"$tempfile"
        rm "$tempfile"
    else
        # Si une description est fournie, la mettre dans les lignes
        if [ -z "$scope" ]; then
            lines=("${type}: ${description}")
        else
            lines=("${type}(${scope}): ${description}")
        fi
    fi

    commit_command="git commit"
    for line in "${lines[@]}"; do
        commit_command+=" -m \"$line\""
    done

    # Exécuter la commande git commit et gérer les erreurs
    if eval "$commit_command"; then
        echo -e "${GREEN}Commit successful: ${lines[0]}${NC}"
    else
        echo -e "${RED}Commit failed. Please check the output above.${NC}"
    fi
}

##########################################################
#   Ouverture de l'url
##########################################################
# Fonction principale pour obtenir l'URL GitLab
function g.() {
    local url
    url="$(get_gitlab_url "$@")"

    if [ -z "${url}" ]; then
        return 1
    fi

    echo "${url}"
    xdg-open "${url}" &>/dev/null
}

function get_gitlab_url() {
    local branch=""
    local remote=""
    local option

    # Traitement des arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
        --branch | -b)
            branch="$2"
            shift
            ;;
        --remote | -r)
            remote="$2"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            return 1
            ;;
        esac
        shift
    done

    # Si le remote n'est pas spécifié, on essaie de le récupérer
    if [ -z "$remote" ]; then
        remote=$(get_remote_url)
    fi

    # Si la branche n'est pas spécifiée, on essaie de récupérer la branche courante
    if [ -z "$branch" ]; then
        branch=$(get_current_branch)
    fi

    # Convertir l'URL distante SSH en URL HTTP(S)
    remote=$(convert_ssh_to_http "${remote}")

    # Construire l'URL GitLab
    local pathname
    pathname=$(echo "$remote" | sed 's/\.git\/\?$//')
    echo "${pathname}/tree/${branch}"
}

# Récupérer l'URL distante du dépôt
function get_remote_url() {
    # Supposons que nous voulons obtenir l'URL du remote "origin"
    git remote get-url origin
}

# Récupérer la branche courante
function get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Convertir une URL SSH en URL HTTP(S)
function convert_ssh_to_http() {
    local ssh_url="$1"
    if [[ "$ssh_url" =~ ^git@(.*):(.*) ]]; then
        echo "https://${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
    elif [[ "$ssh_url" =~ ^ssh://(.*)/(.*) ]]; then
        echo "https://${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
    else
        echo "$ssh_url"  # Retourner l'URL inchangée si ce n'est pas SSH
    fi
}

function gcm_fixup() {
    # Vérifier s'il y a des modifications à commettre
    if [ -n "$(git diff --cached)" ]; then
        # Effectuer le commit fixup
        git commit --fixup=HEAD -m "TO FIXUP"

        if [ -n "$(git diff)" ]; then
            echo "Des modifications non indexées détectées. Remise des modifications..."
            git stash
        fi

        git rebase -i --autosquash HEAD~2

        # Récupérer les modifications remises, si applicable
        if git stash list | grep -q "stash@{0}"; then
            git stash pop
        fi
    fi

}
