# minebox::users::screen
#
# Generates a .screenrc file for the miner user and
# runs screen 60 seconds after boot.
#
# @summary A short summary of the purpose of this class
#
# NOTE - hybrid amd/nv not supported by the YET
# NOTE - need to consolidate and/or refactor screenrc templates
# @example
#   include minebox::users::screen
class minebox::users::screen {

  if $::minebox::nv_conf['enable'] == true {
    file { "/home/${minebox::miner_user}/.screenrc" :
      ensure  => file,
      content => epp(
        'minebox/nvidia/screenrc.epp',
        {
          #'gpu_cfg' => $minebox::nv_conf['gpus'],
          'gpu_cfg' => lookup('minebox::nv_conf.gpus', {merge => 'hash'}),
          }
        ),
      owner   => $minebox::miner_user,
      group   => $minebox::miner_group,
      mode    => '0774',
    }
  }

  $cron_screen = 'absent'

  if $::minebox::amd_conf['use_docker'] == true {
    file { "/home/${minebox::miner_user}/.screenrc" :
      ensure  => file,
      content => epp(
        'minebox/docker/screenrc.epp',
        {
          'gpu_cfg' => $minebox::amd_conf['gpus'],
          }
        ),
      owner   => $minebox::miner_user,
      group   => $minebox::miner_group,
      mode    => '0774',
    }
  }
  elsif $::minebox::amd_conf['enable'] == true {
    $cron_screen = 'present'

      file { "/home/${minebox::miner_user}/.screenrc" :
        ensure  => file,
        content => epp(
          'minebox/amd/screenrc.epp',
          {
            'mining_script' => "screen -t miner ${minebox::base_path}/scripts/claymore.sh",
            }
          ),
        owner   => $minebox::miner_user,
        group   => $minebox::miner_group,
        mode    => '0774',
      }

      cron { 'Screen Setup' :
        ensure  => $cron_screen,
        command => 'sleep 40 && /usr/bin/screen -d -m',
        user    => $minebox::miner_user,
        special => 'reboot',
      }
  }

}
