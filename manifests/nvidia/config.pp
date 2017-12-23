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
  $gpu_cfg = $minebox::nv_gpus #lookup('minebox::nvidia::config::gpus')
  $gpu_fan = $minebox::gpu_fan #lookup('minebox::nvidia::config::gpu_fan')

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

  # Update xorg config when cards change
  exec { 'Reconfigure Xorg' :
    subscribe   => File["${scripts_path}/nvoc.sh"],
    refreshonly => true,
    command     => "${scripts_path}/conf-nv.sh",
    #notify      => Reboot['after_run']
  }

  # Add nvoc to rc.local so it executes after boot
  file_line { 'Add nvoc.sh to rc.local' :
    path => '/etc/rc.local',
    line => " bash ${scripts_path}/nvoc.sh >/dev/null 2>&1",
  }

  -> file { "${scripts_path}/nvoc.sh" :
    ensure  => file,
    content => epp('minebox/nvoc.sh.epp',
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
