require 'lxc'

class Container
  attr_accessor :name, :type, :memory, :cpus

  def initialize(args)
    @container_info = args
    name, type, memory, cpus = *args
    container = new_container(type)
    container.clone(name)
    sleep(10)
  end

  def new_container(param)
    LXC::Container.new(param)
  end

  def create_and_start
    @container = new_container(@container_info[0])
    @container.start
    @container.sleep(5)
  end

  def set_cgroup_limits
    @container.set_cgroup_item("memory.limit_in_bytes", "#{@container_info[2]}")
    @container.set_cgroup_item("cpuset.cpus", "#{@container_info[3]}")
  end

  def attach
    @container.attach do 
      LXC.run_command('ifconfig eth0')
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
