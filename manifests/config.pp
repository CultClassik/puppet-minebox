# minebox::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::config
class minebox::config {
  #include minebox::docker::config

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

  # MOVED TO MINEBOX::NVIDIA::CONFIG - remove this after testing is good
  # Make rc.local executible so we can run stuff there
  #file { '/etc/rc.local' :
  #  ensure => file,
  #  mode   => '0744',
  #}

    exec { 'Update xdm' :
    command     => '/usr/sbin/update-rc.d xdm defaults & /bin/sync',
    refreshonly => true,
    subscribe   => File_line['GRUB_CMDLINE_LINUX'],
    notify      => Reboot['after_run'],
  }

  reboot { 'after_run' :
    apply => finished,
  }

  #######################################################################################################
  # Might want to just call a install or base class and make decisions over there, for now this is here.#
  #######################################################################################################
  #if $minebox::cpu_mining == true {
  #  include minebox::system::hugepages
  #  include minebox::docker::containers::xmr_cpu
  #  include minebox::docker::containers::portainer
  #  Class['::minebox::system::hugepages']
  #  -> Class['::minebox::docker::containers::xmr_cpu']
  #}

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
