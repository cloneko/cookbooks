#
# Cookbook Name:: docker-init
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#
#
#

package 'apt-transport-https' do
	action :install
end

execute "apt-key add" do
	command "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9"
	action :run
end

cookbook_file "docker.list" do 
	path "/etc/apt/sources.list.d/docker.list"
	action :create_if_missing
end

execute "aptitude update" do
	command "aptitude update"
	action :run
end

package "lxc-docker" do
	action :install
end
