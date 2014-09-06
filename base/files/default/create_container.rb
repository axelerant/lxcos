#!/opt/chef/embedded/bin/ruby
require 'lxc'
#require 'lxc-extra'
require 'mixlib/cli'

    class Container
      include Mixlib::CLI

      option :name,
        :short => "-n name",
        :long => "--name name",
        :required => true,
        :description => "Name of the container to be created"

      option :type,
        :short => "-t type",
        :long => "--type type",
        :required => true,
        :description => "Type of the container to be created"

      option :memory,
        :short => "-m memory",
        :long => "--memory memory",
        :default => '256M',
        :description => "Memory to be allocated to the container"

      option :cpus,
        :short => "-c cpus",
        :long => "--cpus cpus",
        :default => '0',
        :description => "number of cpus to be allocated for the container"


      option :help,
        :short => "-h",
        :long => "--help",
        :description => "Show this message",
        :on => :tail,
        :boolean => true,
        :show_options => true,
        :exit => 0

      def init(argv=ARGV)
        parse_options(argv)
        puts config.inspect
        container = new_container(config[:type])
        container.clone(config[:name], flags: LXC::LXC_CLONE_SNAPSHOT, bdev_type:  'overlayfs' )
      end

      def new_container(param)
        LXC::Container.new(param)
      end

      def create_and_start
        @container = new_container(config[:name])
        @container.start
        sleep(5)
        @container.set_cgroup_item("memory.limit_in_bytes", config[:memory])
        @container.set_cgroup_item("cpuset.cpus", config[:cpus])
        sleep(5)
        puts @container.ip_addresses
      end

    end

    container = Container.new
    container.init
    container.create_and_start

