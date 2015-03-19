#!/bin/sh

echo "Beginning the bootstrap script..."

cd ~

echo "Installing packages..."
sudo apt-get update
sudo apt-get install mercurial git python-dev python-docutils


echo "Building latest mercurial..."
if [ ! -d "hg" ]; then
  hg clone http://selenic.com/hg/ --config extensions.hgext.progress=
fi

cd hg
hg checkout -q stable
sudo make --quiet install
echo "Latest mercurial installed..."

cd ~

if [ ! -d "unified" ]; then
  echo "Cloning mozilla-central. This will take a while..."
  # Force the progress extension so we can at least get a bit of an ETA for the clone.
  hg clone https://hg.mozilla.org/mozilla-central unified --config extensions.hgext.progress=
else
  # If there's already a folder named 'unified', I assume it's our unified repository, so don't re-clone it.
  echo "mozilla-central is already cloned. Skipping to next step..."
fi

# If there's no .hgrc file when the script runs, create one with all of the required extensions pre-set.
if [ ! -f ~/.hgrc ]; then
  echo "No .hgrc file found at ~/.hgrc"
  echo "Creating it now..."
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
firefoxtree = ~/.mozbuild/version-control-tools/hgext/firefoxtree

[defaults]
qnew = -U
EOM
else
  echo "Global .hgrc file found, no need to create one."
fi

cd unified
# If there's no .mozbuild folder, then this is the first time mercurial-setup has been run,
# which means we have to run it twice. We only need to run it once if .mozbuild exists, though.
if [ ! -d "~/.mozbuild" ]; then
  ./mach mercurial-setup
fi

echo "Time to configure mercurial...\n\n\n"
echo "At a minimum, please enter your name and email address. Other fields are optional.\n\n\n"

./mach mercurial-setup

echo "Mercurial configuration complete. Creating unified repository..."

echo "Pulling mozilla-central..."
hg -q pull central
echo "Pulling integration branches..."
hg -q pull integration
echo "Pulling release branches..."
hg -q pull releases
hg up central

echo "Unified repository created. Enjoy!"

