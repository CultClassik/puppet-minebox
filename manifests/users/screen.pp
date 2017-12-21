# minebox::users::screen
#
# Generates a .screenrc file for the miner user and
# runs screen 60 seconds after boot.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::users::screen
class minebox::users::screen {

  if $::minebox::gpu_type == 'nvidia' {
    file { '/home/miner/.screenrc' :
      ensure    => file,
      content   => epp(
        'minebox/screenrc.epp',
        {
          'gpu_cfg' => $minebox::nv_gpus
          }
        ),
      owner     => $minebox::miner_user,
      group     => $minebox::miner_group,
      mode      => '0774',
      subscribe => File["/home/${minebox::miner_user}"],
    }
  }

  ##### ADD ELSE HERE TO GENERATE SCREENRC FOR AMD SYSTEMS

  -> cron { 'Screen Setup' :
    ensure  => present,
    command => 'sleep 40 && /usr/bin/screen -d -m',
    user    => $minebox::miner_user,
    special => 'reboot',
  }

}
