#
# Cookbook Name:: wordpress
# Recipe:: default
# # Copyright 2014, Yuu Yonasiro #
# All rights reserved - Do Not Redistribute
#

%w{apache2 php5 php5-mysql mysql-server}.each do |p|
	package p do
		action :install
	end
end

service "apache2" do
	action [:restart, :enable]
end

service "mysql" do
	action [:restart, :enable]
end

remote_file "#{node['documentroot']}/wordpress.tgz" do
	source "#{node['wordpress']['download']}"
	action :create_if_missing
end

execute "Extract Wordpress" do
	cwd "#{node['documentroot']}"
	command "tar zxpf wordpress.tgz && chown www-data wordpress"
	not_if { ::File.exists?("#{node['documentroot']}/wordpress")}
	action :run
end

template "/tmp/initial.dump" do
		source "initial.dump.erb"
		mode 0440 
		variables({
			:db => node['wordpress']['mysql_db'],
			:user => node['wordpress']['mysql_id'],
			:pw => node['wordpress']['mysql_pw'] 
		})

		action :create
end

execute "MySQL CREATE" do
	command "mysql -u root < /tmp/initial.dump"
	action :run
end
