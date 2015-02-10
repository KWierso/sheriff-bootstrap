# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.boot_timeout = 1000

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  end

  # This folder will be shared with the Vagrant instance and will store 
  # the repositories in it. Change "~/mozilla" to some other location 
  # if you already have mozilla-central cloned elsewhere on your host.
  config.vm.synced_folder "~/mozilla", "/home/vagrant/mozilla", type: "nfs", create: true
  config.vm.synced_folder ".", "/home/vagrant/sheriff-bootstrap", type: "nfs"

  # Set up the VM with everything we need. Installs the distro's hg and git
  # so we can clone mercurial's hg repo and build the latest stable version.
  config.vm.provision "shell", inline: <<-UPDATEPACKAGES
    echo "UPDATING PACKAGES"
    sudo apt-get -qq update
    hg -q version
    echo "INSTALL MERCURIAL"
    sudo apt-get -qq install mercurial
    hg -q version
    echo "INSTALL GIT"
    sudo apt-get -qq install git
    echo "INSTALL PYTHON-DEV"
    sudo apt-get -qq install python-dev
    echo "INSTALL PYTHON-DOCUTILS"
    sudo apt-get -qq install python-docutils
  UPDATEPACKAGES

  # Actually clone mercurial's hg repo and build from source. This gives us 
  # the most recent stable release of mercurial every time.
  config.vm.provision "shell", inline: <<-GETHG
    if [ ! -d "hg" ]; then
      echo "CLONING HG"
      hg clone -q http://selenic.com/hg/
      cd hg
    fi
	  hg checkout -q stable
    echo "INSTALLING HG"
	  sudo make --quiet install
  GETHG

  # This isn't needed anymore if the cloning happens with the bootstrap script.
  config.vm.provision "shell", inline: <<-GETUNIFIED
  #  cd mozilla
  #  if [ ! -d "unified" ]; then
  #    echo "GETTING m-c BUNDLE"
  #    if [ ! -e "/home/vagrant/mozilla/mozilla-central.hg" ]; then
  #      wget http://ftp.mozilla.org/pub/mozilla.org/firefox/bundles/mozilla-central.hg
  #    fi
  #    mkdir unified
  #    hg init unified
  #  fi
    echo "Done with provisioning!"
    echo ""
    echo ""
    echo ""
    echo "Next, run vagrant ssh"
    echo "Then run ./sheriff-bootstrap/bootstrap.sh once you're in the VM to clone m-c and do a mercurial sanity check"
  GETUNIFIED
end
