
# Cookbook:: webby
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'selinux::permissive'
include_recipe 'webby::firewall'
include_recipe "dhcp::server"
include_recipe 'selinux::_common'
include_recipe 'sysctl::default'


package 'httpd'
package 'dhcp3-server'
package 'firewalld'
package 'SELinux'
package 'avahi-daemon'
package 'ip6tables'
package 'cron'


selinux_state 'SELinux Disabled' do
	  action :disabled
end
service 'firewalld' do
	  action [:enable, :start]
end

service 'firewalld' do
	  action [:disable, :stop]
end

service "avahi-daemon" do
	  service_name node['avahi-daemon']['service']['name']
	    action [ :stop, :disable ]
end
sysctl_param 'vm.swappiness' do
	      value 2
end

service 'httpd' do
	  action [:enable, :start]
end

service "dhcp3-server" do
	  supports :restart => true, :status => true, :reload => true
	    action [ :enable ]
end

service "ip6tables" do
	  action :disable
end

service 'cron' do
	  service_name node['cron']['service_name']
	    action [:enable, :start]
endi


file '/var/www/html/index.html' do
	  content '<html>
	    <body>
	        <h1>hello world</h1>
	    </body>
	           </html>'
end
