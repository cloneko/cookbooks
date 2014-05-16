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

bash "Extract Wordpress" do
	cwd "#{node['documentroot']}"
	command <<-EOH
	tar zxpf wordpress.tgz
	EOH
end

bash "MySQL CREATE" do
	command <<- EOH
	echo "CREATE DATABASE #{node['wordpress']['mysql_db']} DEFAULT CHARACTER SET UTF8" | mysql -u root
	echo "GRANT ALL PRIVILEGES ON #{node['wordpress']['mysql_db']}.* TO #{node['wordpress']['mysql_id']}@localhost identified by '#{node['wordpress']['mysql_pw']}'" | mysql -u root #{node['wordpress']['mysql_db']}
	EOH
end
