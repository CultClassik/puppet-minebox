# minebox::users::screen
#
# Generates a .screenrc file for the miner user and
# runs screen 60 seconds after boot.
#
# @summary A short summary of the purpose of this class
#
# NOTE - hybrid amd/nv not supported by the YET
# @example
#   include minebox::users::screen
class minebox::users::screen {


  if $::minebox::nv_conf['enable'] == true {
    file { "/home/${minebox::miner_user}/.screenrc" :
      ensure  => file,
      content => epp(
        'minebox/nvidia/screenrc.epp',
        {
          'gpu_cfg' => $minebox::nv_conf['gpus'],
          }
        ),
      owner   => $minebox::miner_user,
      group   => $minebox::miner_group,
      mode    => '0774',
    }
  }

  $mining_script = $::minebox::amd_conf['use_docker'] ? {
    true  => '# nothing goes here for now, see module manifest:  minebox::users::screen',
    false => "screen -t miner ${minebox::base_path}/scripts/claymore.sh",
  }

  if $::minebox::amd_conf['enable'] == true {
    file { "/home/${minebox::miner_user}/.screenrc" :
      ensure  => file,
      content => epp(
        'minebox/amd/screenrc.epp',
        {
          'mining_script' => $mining_script,
          }
        ),
      owner   => $minebox::miner_user,
      group   => $minebox::miner_group,
      mode    => '0774',
    }
  }

  $cron_screen = $minebox::amd_conf['use_docker'] ? {
    true  => 'absent',
    false => 'present',
  }

  cron { 'Screen Setup' :
    ensure  => $cron_screen,
    command => 'sleep 40 && /usr/bin/screen -d -m',
    user    => $minebox::miner_user,
    special => 'reboot',
  }

}
