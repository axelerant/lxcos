lxcos
=====

Base Operating System for building Containers.

Installation
============

LXCOs - 0.1-alpha is out for testing. Following are the steps for installation.
This is aimed at public clouds and can be tested on AMazon EC2. Bare metal iso
is on the way.

#Requirements
* Chef Server
* Chef Workstation
* Amazon EC2 Account
* knife ec2 wrapper on Chef Workstation

#Steps
* Clone the repo form https://github.com/axelerant/lxcos
* git checkout 0.1-alpha.
* Create a github repo with your public keys in a text file "keys". This is safe. Trust me.
* Modify line 18 with the repository to your keys.
* knife cookbook upload -o /path/to/lxcos base
* knife ec2 server create -r "recipe[base::install],recipe[base::configure]" -I ami-80778be8 --flavor t1.micro -G &ltsecurity-group&gt -Z &ltzone&gt -x ubuntu -S &ltkeyname&gt -N &ltnode-name&gt -i &lt/path/to/key&gt -K &lt<AMAZONSECRETKEY&gt -A &ltAMAZONACCESSKEY&gt --ebs-size G
* Make sure that you have a security group with 22 and 80 open
* Wait for a while. Amazon micro instances are slow and being free provisioning is more slow.
* After provisioned, ssh goatos@&ltec2-url&gt
* Finished.

Usage
=====

* create_container &ltcontainer-name&gt &ltcontainer-type&gt(WIP. Does not work in 0.1-alpha)
* Instead run, lxc-clone -o lamp-template -n &ltnew-template-name&gt
* lxc-ls --fancy
* Look at the IP and login as ssh ubuntu@IP. Password is 'ubuntu' 
* Currently container type is only 'lamp-template'


TODO(In Beta)
=============

1. Finish the create_container utility
2. Make more templates
3. Automate HAProxy redirection based on container names and expose port 80 of containers.


Website
=======

http://lxcos.io
