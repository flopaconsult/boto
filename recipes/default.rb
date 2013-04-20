Chef::Log.info("Starting Boto recipe...........")
Chef::Log.info("Create directory /opt/boto...........")
directory "#{node["boto"]["directory"]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
Chef::Log.info("Install git package...........")
package "git-core" do
  action :install
end

Chef::Log.info("Checkout boto...........")
execute "Checkout boto" do
  cwd "#{node["boto"]["directory"]}"
  user "root"
  command "rm -r boto;sudo git clone git://github.com/boto/boto.git"
  action :run
end

Chef::Log.info("Install boto...........")
execute "Install boto" do
  cwd "#{node["boto"]["directory"]}/boto"
  user "root"
  command "sudo python setup.py install"
  action :run
end

