default['workdir'] = '/tmp'
default['tftpbootdir'] = '/var/lib/tftpboot'

# Boot mode switch(efi or bios)
default['bootmode'] = 'efi'

default['bootfile']['efi'] = 'elilo-3.16-x86_64.efi'
default['bootfile']['bios'] = 'pxelinux.0'

