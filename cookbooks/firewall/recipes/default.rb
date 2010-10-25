config_path = "/etc/shorewall"

package "shorewall" do
  action :install
end

cookbook_file "/etc/default/shorewall" do
  source "shorewall-enable"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "#{config_path}/shorewall.conf" do
  source "shorewall.conf"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "#{config_path}/interfaces" do
  source "interfaces"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "#{config_path}/zones" do
  source "zones"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "#{config_path}/policy" do
  source "policy"
  mode 0644
  owner "root"
  group "root"
end

template "#{config_path}/rules" do
  source "rules.erb"
  mode 0644
  owner "root"
  group "root"
  variables(:rule_list => node[:config][:firewall][:rules])
end

service "shorewall" do
  supports :restart => true
  action :enable
  subscribes :restart, resources(:cookbook_file => "#{config_path}/shorewall.conf",
                                 :cookbook_file => "#{config_path}/interfaces", 
                                 :cookbook_file => "#{config_path}/zones", 
                                 :cookbook_file => "#{config_path}/policy", 
                                 :template => "#{config_path}/rules"), :immediately
end
