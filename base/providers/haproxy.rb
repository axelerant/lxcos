action :create do
  log "Adding '#{new_resource.name}' haproxy entry as #{new_resource.title}!"
  template new_resource.path do
    owner node['goatos']['user']
    group node['goatos']['user']
    mode 0644
    extend Helper
    variables(
    containers: container_ips('goatos'),
    start_port: 8000
    )
    source "#{new_resource.name}" + ".erb"
  end
end

action :remove do
  Chef::Log.info "Removing '#{new_resource.name}' template #{new_resource.path}"
  file new_resource.path do
    action :delete
  end
end
