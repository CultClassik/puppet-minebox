# minebox::users::screen
#
# Runs screen 60 seconds after boot
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::users::screen
class minebox::users::screen {

###### Need to add logic around this, script output should vary based on minebox::gpu_type value

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

  -> cron { 'Screen Setup' :
    ensure  => present,
    command => 'sleep 40 && /usr/bin/screen -d -m',
    user    => $minebox::miner_user,
    special => 'reboot',
  }

}
