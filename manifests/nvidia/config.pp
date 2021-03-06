# minebox::nvidia::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::config
class minebox::nvidia::config(
  Hash $nv_conf,
){

  $scripts_path = "${minebox::base_path}/scripts"
  $gpu_cfg = $nv_conf['gpus']
  $gpu_fan = $nv_conf['gpu_fan']

  include minebox::xorg::headless

  file { '/etc/systemd/system/nvidia-persistenced.service' :
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => epp('minebox/nvidia/nvidia-persistenced.epp',
      { 'user_name' => 'root', }
    )
  }

  service { 'nvidia-persistenced' :
    ensure  => running,
    require => File['/etc/systemd/system/nvidia-persistenced.service'],
  }

  # Deploy xorg reconfig script
  file { "${scripts_path}/conf-nv.sh" :
    ensure => file,
    owner  => $minebox::miner_user,
    group  => $minebox::miner_group,
    mode   => '0774',
    source => 'puppet:///modules/minebox/conf-nv.sh',
  }

  # Update xorg config when cards change.
  exec { 'Reconfigure Xorg' :
    subscribe   => File["${scripts_path}/nvoc.sh"],
    refreshonly => true,
    command     => "${scripts_path}/conf-nv.sh",
    notify      => Reboot['after_run']
  }

  file_line { 'rc.local-nvoc.sh' :
    path              => '/etc/rc.local',
    #line             => "/bin/bash ${scripts_path}/nvoc.sh >/dev/null 2>&1",
    line              => "${scripts_path}/nvoc.sh 30 &",
    match             => "^${scripts_path}/nvoc.sh",
    match_for_absence => true,
    after             => File['/etc/rc.local'],
  }

  # Generate Nvidia overclock script using minebox::nv_conf gpu params.
  file { "${scripts_path}/nvoc.sh" :
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
    notify  => Exec['Apply Nvidia OC Settings'],
  }

  exec { 'Apply Nvidia OC Settings' :
    command     => "${scripts_path}/nvoc.sh",
    refreshonly => true,
  }

  cron { 'nvoc':
    command => 'sleep 2m && bash /minebox/scripts/nvoc.sh >/dev/null 2>&1',
    user    => 'root',
    special => 'reboot',
    require => File["${scripts_path}/nvoc.sh"],
  }

}
