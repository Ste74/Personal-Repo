#!/bin/bash

##This is a simple GUI to build pkg for Manjaro

path=~/Github/Manjaro #Set the folder for manjaro github repo overlay pkgs

clear

#Trap for error
trap() {
[ $? -eq 0 ] || exit 0
clear
}

## Select the Repository of Packages
# The name is the exact of repo online on github 

repo=$( zenity --list --radiolist --width=600 --height=300 --title="Gui for Build pkgs" --text="Select Repository" --column="Select" --column="Repository" \
TRUE packages-community \
FALSE packages-multilib \
FALSE packages-core \
FALSE packages-extra 
)

trap

## Select option to build

option=$(zenity --list --checklist --width=600 --height=300 --title="Gui for Build pkgs" --separator=" -" --text="Select option" \
--print-column=2 \
--column="Select" --column="Option" --column="Description" \
false "c" "Recreate chroot" \
true "s" "Signin the pkg" \
true "w" "Delete workdir" \
false "n" "Ncap (install in workdir)" \
false "q" "Query build"
)

trap

## Query to ask typo of pkg
pkgs=$(zenity --list --radiolist --width=600 --height=300 --title="Gui for Build pkgs" --text="Select if pkg or list" \
--print-column=2 \
--column="Select" --column="Type" \
true "Pkg" \
false "List"
)

trap

# Choice the pkgs
if [ "$pkgs" == "List" ]; then 
   pkg=$(zenity --entry --entry-text="List name")
   pkgs=$(zenity --width=600 --height=300 --title="Gui for Build pkgs" --text="Select PKGBUILD dir" --file-selection --directory --filename="$path/$repo/")
elif [ "$pkgs" == "Pkg" ]; then
   pkgs=$(zenity --width=600 --height=300 --title="Gui for Build pkgs" --text="Select PKGBUILD dir" --file-selection --directory --filename="$path/$repo/")

pkg=$(echo "$pkgs" | rev | cut -d'/' -f 1 | rev) 

fi

## Query for build any arch or not
arch=$(zenity --list --radiolist --width=600 --height=300 --title="Gui for Build pkgs" --text="Select how to build" \
--print-column=2 \
--column="Select" --column="Arch" \
true "x86_64 - any" \
false "i686 - x86_64"
)

trap

# Start building

if [ "$arch" = "x86_64 - any" ]; then 
     cd $pkgs
     cd ../
    buildpkg -p $pkg -$option
else 
cd $pkgs
     cd ../
     for ARCH in x86_64 i686 ; do
     buildpkg -p $pkg -a $ARCH -$option
     done
fi

exit 0
