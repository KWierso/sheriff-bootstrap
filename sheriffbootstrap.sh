#!/bin/bash
# Mozilla Sheriffing Bootstrapping Script
# Wes Kocher

echo "Cloning needed repositories to ~/sheriffing/"

# Make the sheriffing folder
cd ~/
mkdir sheriffing
cd sheriffing

# Clone version-control-tools
hg clone https://hg.mozilla.org/hgcustom/version-control-tools

# Clone mozilla-central
hg clone https://hg.mozilla.org/mozilla-central


