Chef::Log.info("checkec2events.sh...........")
template "#{node["boto"]["directory"]}/boto/checkec2events.sh" do
  source "checkec2events.sh.erb"
  mode 0644
  variables(
    :aws_key_id => "#{node["aws_access_key_id"]}",
	:aws_secret_key =>  "#{node["aws_secret_access_key"]}"
  )
end

template "#{node["boto"]["directory"]}/boto/checkec2events_command" do
  source "checkec2events_command.erb"
  mode 0644
  variables(
    :script_folder => "#{node["boto"]["directory"]}/boto/"
	
  )
end

template "#{node["boto"]["directory"]}/boto/checkec2events_service" do
  source "checkec2events_service.erb"
  mode 0644
end


Chef::Log.info("append to commands...........")
execute "append to commands" do
 
  user "root"
  command "cat #{node["boto"]["directory"]}/boto/checkec2events_command >> #{node[:nagios][:dir]}/#{node[:nagios][:config_subdir]}/commands.cfg"
  action :run
  not_if "less /etc/nagios3/conf.d/commands.cfg |grep ec2events"
end



Chef::Log.info("append to services...........")
execute "append to services" do
 
  user "root"
  command "cat #{node["boto"]["directory"]}/boto/checkec2events_service >> #{node[:nagios][:dir]}/#{node[:nagios][:config_subdir]}/services.cfg"
  action :run
  not_if "less /etc/nagios3/conf.d/services.cfg |grep ec2events"
end
Chef::Log.info("make it executable...........")
execute "checkec2events executable" do
 
  user "root"
  command "sudo chmod \"a+rwx\" #{node["boto"]["directory"]}/boto/checkec2events.sh" 
  action :run
end
Chef::Log.info("append to services...........")
execute "restart nagios" do
 
  user "root"
  command "sudo /etc/init.d/nagios3 restart"
  action :run
end


