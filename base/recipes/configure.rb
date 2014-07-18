chef_gem "sshkey" do
  action :install
end

require 'sshkey'

u_start, u_range = ::File.read('/etc/subuid').scan(/goatos:(\d+):(\d+)/).flatten
g_start, g_range = ::File.read('/etc/subgid').scan(/goatos:(\d+):(\d+)/).flatten

template '/opt/goatos/.config/lxc/default.conf' do
  owner node['goatos']['user']
  group node['goatos']['group']
  mode 0644
  source 'lxc.conf.erb'
  variables(
    u_start: u_start,
    u_range: u_range,
    g_start: g_start,
    g_range: g_range
  )
end

template '/opt/goatos/.local/share/lxc/lamp-template/config' do
  owner node['goatos']['user']
  group node['goatos']['group']
  mode 0644
  source 'lamp.conf.erb'
  variables(
    u_start: u_start,
    u_range: u_range,
    g_start: g_start,
    g_range: g_range
  )
end

#execute "chown-rootfs" do
#  command "chown #{u_start}:#{g_start} /opt/goatos/.local/share/lxc/lamp-template/rootfs -R"
#end


unless ::File.exist?('/opt/goatos/.ssh/authorized_keys')
  k = SSHKey.generate
  file '/opt/goatos/.ssh/authorized_keys' do
    owner node['goatos']['user']
    group node['goatos']['group']
    mode 0400
    content k.ssh_public_key
  end
  node.set['goatos']['sshkey'] = k.private_key
end

git "/opt/goatos/.ssh/admin-keys" do
  repository "https://github.com/axelerant/admin-keys.git"
  revision "master"
  action :sync
end

execute "combine-keys" do
  command "cat /opt/goatos/.ssh/admin-keys/keys >> /opt/goatos/.ssh/authorized_keys"
end

