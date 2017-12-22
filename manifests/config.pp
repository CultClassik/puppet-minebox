# minebox::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::config
class minebox::config {

  # Update bashrc
  $bashrc_files = ["/home/${minebox::miner_user}/.bashrc",'/etc/skel/.bashrc']
  $bashrc_files.each |String $brc| {
    file { $brc :
      ensure => file,
    }
    -> file_line { $brc :
        path   => $brc,
        line   => 'export DISPLAY=:0',
        notify => Exec['Update xdm'],
    }
  }

  # Make rc.local executible so we can run stuff there
  file { '/etc/rc.local' :
    ensure => file,
    mode   => '0744',
  }

  # Prevent PCI-E bus errors caused by power management
  file_line { 'GRUB Conf' :
    path  => '/etc/default/grub',
    line  => 'GRUB_CMDLINE_LINUX="text pci=noaer net.ifnames=0 biosdevname=0"',
    match => '^GRUB_CMDLINE_LINUX=.*$',
  }

  exec { 'Update xdm' :
    command     => '/usr/sbin/update-rc.d xdm defaults & /bin/sync',
    refreshonly => true,
    subscribe   => File_line['GRUB Conf'],
    notify      => Reboot['after_run'],
  }

  reboot { 'after_run' :
    apply => finished,
  }

  if $minebox::cpu_mining == true {
    include minebox::docker::containers::xmr_cpu
  }

  file_line { 'Manage GRUB_CMDLINE_LINUX for grub conf':
    path  => '/etc/default/grub',
    line  => 'GRUB_CMDLINE_LINUX="text pci=nomsi net.ifnames=0 biosdevname=0"',
    match => '^GRUB_CMDLINE_LINUX=.*$',
  }

}
