chef_gem "sshkey" do
  action :install
end

base 'lxc.conf' do
  title "lxc.conf"
  path '/opt/goatos/.config/lxc/default.conf'
  action :create
end

base 'lamp-template' do
  title "lamp.conf"
  path '/opt/goatos/.local/share/lxc/lamp-template/config'
  action :create
end

git "/opt/goatos/.ssh/admin-keys" do
  repository "https://github.com/axelerant/admin-keys.git"
  revision "master"
  action :sync
end

execute "combine-keys" do
  command "cat /opt/goatos/.ssh/admin-keys/keys >> /opt/goatos/.ssh/authorized_keys"
end

execute "cgroups" do
  command "sudo cgm create all goatos && sudo cgm chown all goatos $(id -u goatos) $(id -g goatos) && sudo -u goatos cgm movepid all goatos $$"
end
