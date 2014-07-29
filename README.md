lxcos
=====

Base Operating System for building Containers.

Installation
============

LXCOs - 0.1-beta is out for testing. Following are the steps for installation.
This is aimed at public clouds and can be tested on AMazon EC2. Bare metal iso
is on the way.

#Requirements
* Chef Server
* Chef Workstation
* Amazon EC2 Account
* knife ec2 wrapper on Chef Workstation

#Steps
* Clone the repo form https://github.com/axelerant/lxcos
* git checkout 0.1-beta.
* Create a github repo with your public keys in a text file "keys". This is safe. Trust me.
* Modify line 18 with the repository to your keys.
* knife cookbook upload -o /path/to/lxcos base
* knife ec2 server create -r "recipe[base::install],recipe[base::configure]" -I ami-7050ae18 --flavor t1.micro -G &lt;security-group&gt; -Z &lt;zone&gt; -x ubuntu -S &lt;keyname&gt; -N &lt;node-name&gt; -i &lt;/path/to/key&gt; -K &lt;<AMAZONSECRETKEY&gt; -A &lt;AMAZONACCESSKEY&gt; --ebs-size G
* Make sure that you have a security group with 22 and 80 open
* Wait for a while. Amazon micro instances are slow and being free provisioning is more slow.
* After provisioned, ssh goatos@&lt;ec2-url&gt;
* Finished.

Usage
=====

* /opt/chef/embedded/bin/ruby /usr/local/bin/create_container.rb &lt;container-name&gt; &lt;container-type&gt; &lt;memoryM&gt; &lt;cpus&gt;
* lxc-ls --fancy
* Look at the IP and login as ssh ubuntu@IP. Password is 'ubuntu' 
* Currently container type is only 'lamp-template'
* Alternatively from the workstation run or from the ubuntu user account on the machine run "sudo chef-client -o "role[haproxy]""
* This will add a haproxy entry to the container making it reachable by outer world.


TODO(In 0.1)
=============

1. Make more templates
2. Improve Create container(Cloning) time/performance


Website
=======

http://lxcos.io
