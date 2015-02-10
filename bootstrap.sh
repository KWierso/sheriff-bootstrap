#!/bin/sh

echo "BEGINNING BOOTSTRAP"

cd ~/mozilla
# I tried seeing if unbundling from an hg bundle would work better,
# but it seems to also randomly get killed mid-operation in the
# shared folder, so I'm trying other strategies for setting up.

#hg unbundle mozilla/mozilla-central.hg

if [ ! -d "unified" ]; then
  # This is more convoluted than it should be, but hg clone to the
  # shared mozilla folder keeps getting cut off prematurely during 
  # my testing (I guess because writing to the Windows host is so slow?).
  # Instead, I'll try cloning into an unshared part of 
  # the VM's virtual drive and moving it to the shared folder
  # after it finishes the clone to see if that helps.
  
  # If this doesn't work, I might have to just make people clone m-c
  # from the host side on their own before proceeding with the bootstrap.
  cd ~
  echo "CLONING M-C... THIS WILL TAKE A WHILE"
  # Enable the progress extension just for this so the m-c clone has an ETA
  hg clone https://hg.mozilla.org/mozilla-central unified --config extensions.hgext.progress=
  mv unified/ mozilla/
else
  echo "M-C ALREADY CLONED AND IN PLACE."
fi

# I can't figure out how to get a vagrant synced folder to act as the root of
# the user's home directory, so I'll copy the hgrc file to the synced mozilla
# folder so it doesn't have to be re-written every single time the vm is recreated
if [ ! -f ~/.hgrc ]; then
  echo "NO HGRC FILE FOUND IN VM..."
  if [ -f ~/mozilla/.hgrc ]; then
    echo "COPYING .hgrc FROM HOST'S MOZILLA FOLDER"
    cp ~/mozilla/.hgrc ~/.hgrc
  else
    echo "CREATING IT NOW."
    cat <<EOM > ~/.hgrc
[diff]
git = 1
showfunc = 1
unified = 8
[extensions]
progress =
color =
rebase =
histedit =
mq =
reviewboard = /home/vagrant/.mozbuild/version-control-tools/hgext/reviewboard/client.py
firefoxtree = /home/vagrant/.mozbuild/version-control-tools/hgext/firefoxtree
[defaults]
qnew = -U
EOM
  fi
else
  echo "HGRC EXISTS, DON'T NEED TO MAKE IT"
fi

# Set up mercurial
cd ~/mozilla/unified
./mach mercurial-setup
./mach mercurial-setup

cp ~/.hgrc ~/mozilla/.hgrc

echo "NOW THAT MERCURIAL IS CONFIGURED, SETTING UP THE UNIFIED REPOSITORY"
echo "(THIS CAN TAKE A WHILE)"
cd ~/mozilla/unified
hg pull integration
hg pull releases
hg up central

echo "ALL DONE! HAVE FUN SHERIFFING"
