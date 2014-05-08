#
# Cookbook Name:: ricty
# Recipe:: default
# # Copyright 2014, Yuu Yonasiro #
# All rights reserved - Do Not Redistribute
#

bash "Clear Cache directory" do
		cwd "#{Chef::Config[:file_cache_path]}"
		code <<-EOH
		rm -fr *
		EOH
end
package "fontforge" do
	action :install
end

package "unzip" do
	action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/Inconsolata.otf" do
	source "http://levien.com/type/myfonts/Inconsolata.otf"
	action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/migu.zip" do
	source node['miguUrl']
	action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/Ricty.zip" do
	source "https://github.com/yascentur/Ricty/archive/master.zip"
	action :create
end

bash "build ricty" do
		cwd "#{Chef::Config[:file_cache_path]}"
		code <<-EOH
		unzip migu.zip
		unzip Ricty.zip 
		mv migu-*/* .
		mv Ricty-*/* .
		./ricty_generator.sh auto
		rm -fr Inconsolata.otf README.md Ricty.zip migu* ipag* misc remote_file ricty_* 
		EOH
end
