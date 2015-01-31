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
  # my testing. Instead, I'll try cloning into an unshared part of 
  # the VM's virtual drive and moving it to the shared folder
  # after it finishes the clone to see if that helps.
  
  # If this doesn't work, I might have to just make people clone m-c
  # from the host side on their own before proceeding with the bootstrap.
  cd ~
  echo "CLONING M-C... THIS WILL TAKE A WHILE"
  hg clone https://hg.mozilla.org/mozilla-central unified
  hg mv unified mozilla/unified
else
  echo "M-C ALREADY CLONED."
fi

# This was only needed if I would use the mercurial bundles, as they
# don't create a pre-filled hgrc in that case. Saving for later if
# I go back to that strategy.

#    cat <<EOM > ~/mozilla/unified/.hg/hgrc
#[paths]
#default = https://hg.mozilla.org/mozilla-central/
#EOM


# Set up mercurial
cd ~/mozilla/unified
./mach mercurial-setup

# Re-run it if needed? I think it'd be better to just make a global
# .hgrc file as part of this bootstrap and then run this script as
# a sanity check.

#./mach mercurial-setup

