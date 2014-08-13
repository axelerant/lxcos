#!/opt/chef/embedded/bin/ruby
require 'lxc'

class Container
  attr_accessor :name, :type, :memory, :cpus

  def initialize(args)
    @container_info = {
      name: args[0],
      type: args[1],
      memory: args[2],
      cpus: args[3],
    }

    container = new_container(@container_info[:type])
    container.clone(@container_info[:name], flags: LXC::LXC_CLONE_SNAPSHOT, bdev_type: 'overlayfs' )
  end

  def new_container(param)
    LXC::Container.new(param)
  end

  def create_and_start
    @container = new_container(@container_info[:name])
    @container.start
    sleep(5)
  end

  def set_cgroup_limits
    @container.set_cgroup_item("memory.limit_in_bytes", @container_info[:memory])
    @container.set_cgroup_item("cpuset.cpus", @container_info[:cpus])
  end

  def attach
    @container.attach do 
    #run custom commands inside containers
    end 
  end

  def get_ips
    @container.ip_addresses
  end

end


arguments = ARGV

if arguments.length == 4
  puts "You have passed correct number of arguments."
  container = Container.new(arguments)
  container.create_and_start
  container.set_cgroup_limits
  container.attach
  puts container.get_ips
else
  puts "Please check the number of arguments passed, it should be four arguments maximum."
end
