#
# Cookbook Name:: notosans
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

remote_file "#{Chef::Config[:file_cache_path]}/NotoSansJapanese.zip" do
	source "http://www.google.com/get/noto/pkgs/NotoSansJapanese-hinted.zip"
	action :create_if_missing
end

directory "/usr/share/fonts/opentype" do
	action :create
end

bash "build noto sans" do
		cwd "#{Chef::Config[:file_cache_path]}"
		code <<-EOH
		unzip -d NotoSansJapanese NotoSansJapanese.zip
		mv -fv ./NotoSansJapanese /usr/share/fonts/opentype
		chmod 644 /usr/share/fonts/opentype/NotoSansJapanese/*.otf
		rm -fr NotoSansJapanses.zip
		fc-cache -fv
		EOH
end
