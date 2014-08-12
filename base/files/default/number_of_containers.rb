#!/opt/chef/embedded/bin/ruby
require 'lxc'

def number_of_containers
  c = LXC::list_containers()
  puts c.count
end

number_of_containers

