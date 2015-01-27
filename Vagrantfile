# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # This folder will be shared with the Vagrant instance and will store 
  # the repositories in it. Change "~/mozilla" to some other location 
  # if you already have mozilla-central cloned elsewhere on your host.
  config.vm.synced_folder "~/mozilla", "/home/vagrant/mozilla", type: "nfs", create: true

  # Set up the VM with everything we need. Installs the distro's hg and git
  # so we can clone mercurial's hg repo and build the latest stable version.
  # Then clone version-control-tools and mozilla-central.
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -q
    sudo apt-get install -y -q mercurial git python-dev python-docutils
	hg clone http://selenic.com/hg/
	cd hg
	hg checkout stable
	sudo make install -s
	cd ../mozilla
	hg clone https://hg.mozilla.org/hgcustom/version-control-tools
	hg clone https://hg.mozilla.org/mozilla-central
  SHELL
end
