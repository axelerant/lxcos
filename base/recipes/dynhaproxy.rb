r = chef_gem "ruby-lxc" do
  action :nothing
end

r.run_action(:install)
Gem.clear_paths

base_haproxy 'haproxy.cfg' do
  title "haproxy.cfg"
  path '/etc/haproxy/haproxy.cfg'
  action :create
end

service "haproxy" do
  supports :status => true
  action :start
end

execute "reload-haproxy" do
  command "sudo haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)"
end
