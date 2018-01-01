# minebox::nvidia::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::config
class minebox::nvidia::config {

  $scripts_path = "${minebox::base_path}/scripts"
  $gpu_cfg = $minebox::nv_gpus
  $gpu_fan = $minebox::gpu_fan

  include minebox::xorg::headless

  file { '/etc/systemd/system/nvidia-persistenced.service' :
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => epp('minebox/nvidia/nvidia-persistenced.epp',
      { 'user_name' => $minebox::miner_user, }
    )
  }

  -> service { 'nvidia-persistenced' :
    ensure => running,
  }

  # Deploy xorg reconfig script
  file { "${scripts_path}/conf-nv.sh" :
      ensure => file,
      owner  => $minebox::miner_user,
      group  => $minebox::miner_group,
      mode   => '0774',
      source => 'puppet:///modules/minebox/conf-nv.sh',
  }

  exec { 'Apply Nvidia OC Settings' :
    command     => "${scripts_path}/nvoc.sh",
    refreshonly => true,
    subscribe   => File["${scripts_path}/nvoc.sh"],
  }

  # Update xorg config when cards change
  exec { 'Reconfigure Xorg' :
    subscribe   => File["${scripts_path}/nvoc.sh"],
    refreshonly => true,
    command     => "${scripts_path}/conf-nv.sh",
    #notify      => Reboot['after_run']
  }

  # Add nvoc to rc.local so it executes after boot
  file { '/etc/rc.local' :
    ensure  => file,
    content => "/bin/bash ${scripts_path}/nvoc.sh >/dev/null 2>&1",
    mode    => '0744',
  }

  -> file { "${scripts_path}/nvoc.sh" :
    ensure  => file,
    content => epp('minebox/nvidia/nvoc.sh.epp',
      {
        'gpu_cfg' => $gpu_cfg,
        'gpu_fan' => $gpu_fan,
        }
      ),
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    mode    => '0774',
  }

  -> if $minebox::use_docker == true {
    class { '::minebox::docker::containers::config' :
      gpus => $gpu_cfg,
    }
  }

}
