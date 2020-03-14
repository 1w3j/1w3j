#!/usr/bin/env bash

check_if_currently_on_home() {
	echo 'Checking if the repo was cloned in your $HOME path...'
	two_dirs_up=$(dirname "$(dirname "$(realpath $0)")")
	if [[ ! $HOME = "$two_dirs_up" ]]; then
		echo "Please run the following command: \`mv $(dirname "$(realpath $0)") $HOME\`"
		exit 163
	fi
}

check_if_currently_on_home
. $(dirname "$0")/functions.sh

SCRIPTS_PATH=~/1w3j/scripts
CONFIG_PATH=~/1w3j/config
BIN_PATH=~/bin
check_if_important_folders_exists() {
	msg "Checking if ${BIN_PATH} exists..."
	if [[ ! -d ${BIN_PATH} ]]; then
		warn "Creating ${BIN_PATH} for you..."
		mkdir ${BIN_PATH}
	fi
}
check_if_important_folders_exists

MY_INTELLIJ_IDES=(
	    idea
	#    webstorm
	#    charm
	#    datagrip
	#    clion
)

link_ides_scripts() {
	warn "If some IDE script is missing, first check jetbrains-toolbox configuration\n and set the Shell Scripts \
            Location to ${SCRIPTS_PATH}"
	for ide in ${MY_INTELLIJ_IDES[*]}; do
		ide_script=${SCRIPTS_PATH}/${ide}
		if [[ -f ${ide_script} ]]; then
			from=${ide_script}
			to=${BIN_PATH}/$(basename ${ide_script})
			echo -e "\t\033[31m$from\033[m ==>> \033[31m$to\033[m"
			rm -f ${to}
			ln -s ${from} ${to}
		else
			warn "${ide} script is missing!"
		fi
	done
}

link_scripts() {
	msg "Found these .$1 scripts:"
	FILES=()
	# globbing files with the specified extension on '$1'
	for f in ${SCRIPTS_PATH}/*.$1; do
		# check if current $f file is actually a file (not dirs) while excluding this script file
		[[ -f "${f}" ]] && [[ "${f}" != "$(realpath $0)" ]] && FIEL=$(basename ${f})
		# note: shortened filenames just for fooling around
		# concatenating the SCRIPTS_PATH "path string", a "/" slash, and the current file string "globbed"
		FILE=${SCRIPTS_PATH}/${FIEL}
		echo -e "\t$FILE"
		# append that string to the FILES array
		FILES=("$FILE" "${FILES[@]}")
		# echo "FILES: " "${FILES[@]}";
	done
	msg "Started linking:"
	# iterating over all files in the array
	for f in "${FILES[@]}"; do
		from=${f}
		#getting the basename of the script file
		to_base=$(basename ${f})
		# trimming out the extension
		to=${BIN_PATH}/${to_base%.*}
		echo -e "\t\033[31m$from\033[m ==>> \033[31m$to\033[m"
		rm -f ${to}
		ln -s ${from} ${to}
	done
	echo -e "\r"
}

link_config_files() {
	msg "Started linking config files"
    warn "WARNING: force -f flag was activated on cp commands, Continue?" && read
	for c in "${CONFIG_PATH}"/*; do
		case "$(basename ${c})" in
		intellij)
			msg "intellij folder detected \"${c}\""
			for ide in ${MY_INTELLIJ_IDES[*]}; do
				source ~/1w3j/scripts/resetintellijkey.sh --just-get-configpath ${ide}
				CURRENT_IDE_CONFIG=$(realpath ${IDE_CONFIG})
				msg "Soft linking config files for ${IDE} "
				if [[ -d ${CURRENT_IDE_CONFIG} ]]; then
					msg ${CURRENT_IDE_CONFIG} "Config folder detected for ${ide}"
					msg "Recursively copying into" ${CURRENT_IDE_CONFIG} "with '-s' flag"
					cp -rsf "${c}"/* ${CURRENT_IDE_CONFIG}
				else
					warn ${CURRENT_IDE_CONFIG} "doesn't exist. Install ${ide} first, then run init.sh"
				fi
			done
			msg "++++++++++++++ IMPORTANT NOTE +++++++++++++++"
			msg "You may now want to run your IDEs right now, if color scheme sets again as in normal (or awful) again,\
                consider running init.sh again before 'restarting your IDE'. This 'may' be due to the plugin version \
                displayed in material_theme.xml. Always update the Material Theme UI Plugin on your IDEs"
			;;
		*)
			from="${c}"
			to=~/."$(basename ${c})"
            if [[ -d "${c}" ]]; then
                cp -rsf ${from}/* ${to} && echo -e "\t\033[31m${from}/*\033[m ==>> \033[31m${to}/\033[m"
            else
                cp -sf "${c}" ${to} && echo -e "\t\033[31m${from}\033[m ==>> \033[31m${to}\033[m"
            fi
		esac
	done
	echo -e "\r"
}

check_zsh() {
	msg "Checking if zsh is your current shell"
	if [[ (! ${SHELL} = "/usr/bin/zsh") && (! ${SHELL} = "/bin/zsh") ]]; then
		warn "Nope, $SHELL is your shell right now, we need to change"
		chsh -s /usr/bin/zsh "${US3R}"
	fi
	msg "Everything will be just fine"
}

print_usage() {
	cat <<EOF

Usage: ${0} [--do-not-install-anything | -dnia ]
Options:
      --do-not-install-anything, -dnia           Just link your config files without installing packages
                                                 listed in ~/1w3j/pkgnames
EOF
}

install_packages() {
    pkgdir="pkgnames"
	pacman_pkgs=$(cat ~/1w3j/${pkgdir}/pacman | tr '\n' ' ')
	yaourt_pkgs=$(cat ~/1w3j/${pkgdir}/yaourt | tr '\n' ' ')
	msg "Starting pacman sync"
	# Deprecated message:
	# msg "DON'T forget to select number 3) when installing 'i3' -> i3blocks";
	sudo pacman -Syyu
	msg "Performing pacman pkgs installation"
	sudo pacman -S ${pacman_pkgs}
	msg "Starting yaourt pkgs installation"
	yaourt -S ${yaourt_pkgs}
	msg "Starting pip modules installation"
	sudo pip install -r ~/1w3j/${pkgdir}/pip
	msg "Starting mhwd -i bumblebee"
	sudo mhwd -i pci video-hybrid-intel-nvidia-bumblebee
	msg "Bootstrapping BlackArch packages"
	sh -c "$(curl -fSsL https://blackarch.org/strap.sh)"
}

init_sh() {
	if [[ "${1}" = "--help" || "${1}" = "-h" ]]; then
		print_usage
		exit 0
	fi
	check_zsh
	link_scripts "sh"
	link_scripts "py"
	link_ides_scripts
	link_config_files
	if [[ ! "${1}" = "--do-not-install-anything" && ! "${1}" = "-dnia" ]]; then
		install_packages
	fi
	wal -i ~/1w3j/wallpapers/OMEN_by_HP.jpg
}

init_sh "$@"