#
# Cookbook Name:: vm
# Recipe:: default
#
# Copyright 2014, Yonashiro Yuu <yonashiro@std.it-college.ac.jp>
#
# All rights reserved - Do Not Redistribute 
#
#

package 'qemu-kvm' do
	package_name 'qemu-kvm'
	action [:install]
end

package 'virt-manager' do
	package_name 'virt-manager'
	action [:install]
end

service 'virt-manager' do
	service_name 'libvirt-bin'
	action [:enable, :start ]
end
