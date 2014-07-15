execute 'apt-get-update' do
  command "sudo apt-get update && sudo apt-get -y upgrade"
end

package 'liblxc1'
package 'lxc'
package 'lxc-dev'
package 'lxc-templates'
package 'python3-lxc'
package 'build-essential'
package 'haproxy'
package 'awscli'
package 'git-core'

gem_package 'ruby-lxc' do
  gem_binary '/opt/chef/embedded/bin/gem'
end

gem_package 'sshkey' do
  gem_binary '/opt/chef/embedded/bin/gem'
end

gem_package 'serfx' do
  gem_binary '/opt/chef/embedded/bin/gem'
end

user 'goatos' do
  home '/opt/goatos'
  supports(manage_home: true)
end

directory '/opt/goatos/.config' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0700
end

directory '/opt/goatos/.config/lxc' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0775
end

directory '/opt/goatos/.local' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.local/share' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.local/share/lxc' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.local/share/lxcsnaps' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.cache' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.cache/lxc' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.ssh' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0700
end

directory '/opt/goatos/lxc.conf.d' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0751
end

directory '/opt/goatos/.aws' do
  user node['goatos']['user']
  group node['goatos']['group']
  mode 0700
end

cookbook_file '/opt/goatos/.aws/config' do
  owner "goatos"
  group "goatos"
  mode 0600
  source "awsconfig"
end

file '/etc/lxc/lxc-usernet' do
  owner 'root'
  group 'root'
  mode 0644
  content "#{node['goatos']['user']} veth lxcbr0 100\n"
end

cookbook_file "/usr/local/bin/create_container.rb" do
  owner "root"
  group "root"
  source "create_container.rb"
end

git "/opt/goatos/.ssh/admin-keys" do
  repository "https://github.com/axelerant/admin-keys.git"
  revision "master"
  action :sync
end

execute "combine-keys" do
  command "cat /opt/goatos/.ssh/admin-keys/keys >> /opt/goatos/.ssh/authorized_keys"
end
