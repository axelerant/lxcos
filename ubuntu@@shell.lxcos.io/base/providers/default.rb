action :create do
  log "Adding '#{new_resource.name}' template as #{new_resource.title}!"
  u_start, u_range = ::File.read('/etc/subuid').scan(/goatos:(\d+):(\d+)/).flatten
  g_start, g_range = ::File.read('/etc/subgid').scan(/goatos:(\d+):(\d+)/).flatten
  template new_resource.path do
    owner node['goatos']['user']
    group node['goatos']['user']
    mode 0644
    source "#{new_resource.name}" + ".erb"
    variables(
      u_start: u_start,
      u_range: u_range,
      g_start: g_start,
      g_range: g_range
    )
  end
end

action :remove do
  Chef::Log.info "Removing '#{new_resource.name}' greeting #{new_resource.path}"
  file new_resource.path do
    action :delete
  end
end
