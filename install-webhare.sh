#!/bin/bash

installpath="$HOME/projects"
##FIXME whalias="eval `~/projects/webhare/whtree/bin/wh setupmyshell`"

printf "\n## This script will install WebHare to $installpath ##\n\n"
printf "## - creating directory $installpath ##\n"
mkdir -p "$installpath"
cd "$installpath"

printf "\n## - cloning WebHare from Gitlab ##\n"
git clone git@gitlab.b-lex.com:webhare/webhare.git webhare

printf "\n## - checkout the correct Git branch ##\n"
cd webhare
git fetch
git checkout -b wh-setupbuild origin/wh-setupbuild

printf "\n## - setting up the 'wh' alias ##\n"
#FIXME! How to add the $whalias line as a line?
#cat "$HOME/.bash_profile" | pbcopy && echo "$whalias" > "$HOME/.bash_profile" && pbpaste >> "$HOME/.bash_profile"
#printf "eval `$HOME/projects/webhare/whtree/bin/wh setupmyshell`"

if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
fi

printf "\n## - running 'wh setupbuild' ##\n"
~/projects/webhare/whtree/bin/wh setupbuild

printf "\n## - update the Makefile ##\n"
cat "$installpath/whbuild/Makefile" | pbcopy && echo "NOTEST=1" > "$installpath/whbuild/Makefile" && pbpaste >> "$installpath/whbuild/Makefile"
#echo "NOTEST=1\nSRCDIR=../webhare\ninclude $(SRCDIR)/base_makefile" > "$installpath/whbuild/Makefile"
cd "$installpath/whbuild/"
make clean

printf "\n## - running the first Make & Install ##\n"
cd "$installpath"
~/projects/webhare/whtree/bin/wh make install
~/projects/webhare/whtree/bin/wh make postuninstall
~/projects/webhare/whtree/bin/wh make postinstall

printf "\n## - running WebHare in the background ##\n"
~/projects/webhare/whtree/bin/wh console &

printf "\n## - installing extra base modules ##\n"
~/projects/webhare/whtree/bin/wh getmodule webhare/socialite
~/projects/webhare/whtree/bin/wh getmodule webhare/tollium_dev
~/projects/webhare/whtree/bin/wh getmodule webhare/google
#FIXME: nerdsandcompany module ---------- wh getmodule git@bitbucket.org:itmundi/nerds-company-webhare-base.git

printf "## - setting up '~/mods/' symbolic link for convenience ##\n"
ln -s "$installpath/webhare/whtree/var/installedmodules" ~/mods

#FIXME: run 'wh console' (screen -r?)

printf "## - run 'wh setupdev', which will setup a basic development environment ##\n"
~/projects/webhare/whtree/bin/wh setupdev

printf "## - all done; performing a soft reset just to be sure ##\n"
~/projects/webhare/whtree/bin/wh softreset

# FIXME: Run extra script to setup e-mail, UA override codes, etc

printf '\n'
