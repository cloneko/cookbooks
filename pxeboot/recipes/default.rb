#
# Cookbook Name:: pxeboot # Recipe:: default
#
# Copyright 2014, Yonashiro Yuu <cloneko@gmail.com>
#
# Under MIT License
#
#
# Ref: https://wiki.ubuntu.com/UEFI/PXE-netboot-install


execute "update package index" do
    command "apt-get update"
    ignore_failure true
    action :nothing
end.run_action(:run)

package 'dnsmasq' do
	action [:install]
end

package 'tftpd-hpa' do
	action [:install]
end

cookbook_file "/etc/default/tftpd-hpa"  do
	source 'tftpd-hpa' 
	mode '0644'
	action [:create]
end

package 'nfs-kernel-server' do
	action [:install]
end

if node['bootmode'] == 'bios' then

	package 'syslinux' do
		action [:install]
	end 

	directory "#{node['tftpbootdir']}/pxelinux.cfg" do
		mode '0755'
		action :create
	end

	execute "link pxelinux.0" do
		command "ln -s /usr/lib/syslinux/pxelinux.0 #{node['tftpbootdir']}/pxelinux.0"
		ignore_failure true
		action :nothing
	end.run_action(:run)

else

	# eLILO for EFI boot
	cookbook_file "#{node['tftpbootdir']}/#{node['bootfile']['efi']}" do
		source   node['bootfile']['efi']
		mode     '0644'
		action :create
	end

end
