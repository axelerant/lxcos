module Helper
  def container_ips(name)
    data = {}
    user = Etc.getpwnam(name)
    config = File.join(user.dir, '.local/share/lxc') # this can be injected from outside as well
    require 'lxc'
    LXC.list_containers(config_path: config).each do |n|
      ct = LXC::Container.new(n, config)
      if ct.running? and (not ct.ip_addresses.empty?)
        data[ct.name] = ct.ip_addresses.first
      end
    end
    data
  end
end
