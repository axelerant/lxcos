u_start, u_range = ::File.read('/etc/subuid').scan(/goatos:(\d+):(\d+)/).flatten
g_start, g_range = ::File.read('/etc/subgid').scan(/goatos:(\d+):(\d+)/).flatten

default['goatos']['user'] = 'goatos'
default['goatos']['group'] = 'goatos'
default['goatos']['subuid'] = <%= @u_start %> 
default['goatos']['subgid'] = <%= @g_start %> 
