# minebox::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::config
class minebox::config {

  reboot { 'after_run' :
    apply => finished,
  }

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

  exec { 'Update xdm' :
    command     => '/usr/sbin/update-rc.d xdm defaults & /bin/sync',
    refreshonly => true,
    subscribe   => File_line['GRUB_CMDLINE_LINUX'],
    notify      => Reboot['after_run'],
  }

  if $minebox::amd_conf['enable'] == true {
    $final_grub_options = "${minebox::grub_options} amdgpu.vm_fragment_size=9"
  } else {
    $final_grub_options = $minebox::grub_options
  }

  file { '/etc/rc.local' :
    ensure => file,
    mode   => '0744',
  }

  # Prevent PCI-E bus errors caused by power management, use normal eth if names
  file_line { 'GRUB_CMDLINE_LINUX':
    path  => '/etc/default/grub',
    line  => 'GRUB_CMDLINE_LINUX="pci=nomsi"', #' net.ifnames=0 biosdevname=0"',
    match => '^GRUB_CMDLINE_LINUX=.*$',
  }

  file_line { 'GRUB_CMDLINE_LINUX_DEFAULT':
    path  => '/etc/default/grub',
    line  => "GRUB_CMDLINE_LINUX_DEFAULT=\"${final_grub_options}\"",
    match => '^GRUB_CMDLINE_LINUX_DEFAULT=.*$',
  }

}
