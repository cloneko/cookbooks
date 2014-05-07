#
# Cookbook Name:: lmde # Recipe:: default
#
# Copyright 2014, Yonashiro Yuu <cloneko@gmail.com>
#
# Under MIT License
#
# Ref: https://wiki.ubuntu.com/UEFI/PXE-netboot-install 

cookbook_file "#{node['workdir']}/lmde.iso" do
	source   node['lmde']['iso']['localmate']
	mode     '0644'
	action :create_if_missing
end

if node['bootmode'] == 'bios' then

	directory "#{node['tftpbootdir']}/pxelinux.cfg" do
		mode '0755'
		action :create
	end

	template "#{node['tftpbootdir']}/pxelinux.cfg/default" do
		source 'pxeboot.conf.erb'
		mode 0640
		owner "root"
		group "root" 
		action :create
	end

	execute "link pxelinux.0" do
		command "ln -s /usr/lib/syslinux/pxelinux.0 #{node['tftpbootdir']}/pxelinux.0"
		ignore_failure true
		action :nothing
	end.run_action(:run)

else

	# eLILO for EFI boot
	template "#{node['tftpbootdir']}/elilo.conf" do
		source   'elilo.conf.erb'
		mode     '0644'
		action :create
	end

end

# IP Address Generate
networkRgx = /^\d+\.\d+\.\d+\./
networkAddr = networkRgx.match(node[:ipaddress]).to_s
startIp = networkAddr + '129'
endIp = networkAddr + '254'


# EFI or Oldstyle BIOS Detect 
bootfile = node['bootmode'] == 'efi' ? node['bootfile']['efi'] : node['bootfile']['bios']

template '/etc/dnsmasq.conf' do
	source 'dnsmasq.conf.erb'
	mode 0600
	owner "root"
	group "root"
	variables({
		:dhcpStart => startIp,
		:dhcpEnd => endIp,
        :bootfile => bootfile
	})

	action :create
end

cookbook_file '/etc/exports' do
    source 'exports'
    mode 0444
	owner "root"
	group "root"
    action :create
end

directory "/mnt/lmde" do
	mode '0755'
	action :create
end

bash "Setup for PXEboot" do
    code <<-EOF
    mount -t iso9660 -o loop /tmp/lmde.iso /mnt/lmde
    ln -s /mnt/lmde/live #{node['tftpbootdir']}/live
    cp #{node['tftpbootdir']}/live/vmlinuz #{node['tftpbootdir']}
    cp #{node['tftpbootdir']}/live/initrd.img #{node['tftpbootdir']} 
    EOF
end

service "dnsmasq" do
	action [:enable, :stop]
end

service "nfs-kernel-server" do
	action [:enable, :restart]
end
