require 'lxc'

class Container
  attr_accessor :name, :type, :memory, :cpus

  def initialize(args)
    @container = {
      name: args[0],
      type: args[1],
      memory: args[2],
      cpus: args[3],
    }

    container = new_container(@container[:type])
    container.clone(@container[:name])
    sleep(10)
  end

  def new_container(param)
    LXC::Container.new(param)
  end

  def create_and_start
    @container = new_container(@container[:name])
    @container.start
    sleep(5)
  end

  def set_cgroup_limits
    @container.set_cgroup_item("memory.limit_in_bytes", "#{@container[:memory]}")
    @container.set_cgroup_item("cpuset.cpus", "#{@container[:cpus]}")
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
