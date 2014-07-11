require "yaml"
require "lxc"

FILENAME = 'containers.yaml'
class Containerinfo
  attr_accessor :name, :type, :memory, :cpus
end

class Drop
   attr_accessor :container_info

  def initialize(obj)
    @container_info = obj
    drop = new_drop(obj.type)
    drop.clone(@container_info.name)
    sleep(10)
  end

  def new_drop(param)
    LXC::Container.new(param)
  end

  def create_and_start
    @droplet = new_drop(@container_info.name)
    @droplet.start
    sleep(5)
  end

  def attach
    @droplet.attach do
     LXC.run_command('sudo superadmin-init')
    end
  end
  
  def set_cgroup_limits
    @droplet.set_cgroup_item("memory.limit_in_bytes", "#{@container_info.memory}")
    @droplet.set_cgroup_item("cpuset.cpus", "#{@container_info.cpus}")
  end

  def get_ips
    @droplet.ip_addresses
  end
end

#get container info
containers = YAML::load(File.open(FILENAME))

containers.each do |con_info|
  drop = Drop.new(con_info)
  drop.create_and_start
  drop.set_cgroup_limits
  drop.attach
  puts drop.get_ips
end
