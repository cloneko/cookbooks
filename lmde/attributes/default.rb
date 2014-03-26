default['lmde']['iso']['cinnamon'] = 'http://172.16.40.3/isos/linux/linuxmint-201403-cinnamon-dvd-64bit.iso'
default['lmde']['iso']['mate'] = 'http://172.16.40.3/isos/linux/linuxmint-201403-mate-dvd-64bit.iso'

default['lmde']['iso']['localmate'] = 'linuxmint-201403-cinnamon-dvd-64bit.iso'

default['workdir'] = '/tmp'
default['tftpbootdir'] = '/var/lib/tftpboot'

# Boot mode switch(efi or bios)
default['bootmode'] = 'efi'

default['bootfile']['efi'] = 'elilo-3.16-x86_64.efi'
default['bootfile']['bios'] = 'pxelinux.0'

