# minebox::users::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::users::install
class minebox::users::install {
  # If the user is managed in a linux server base profile, we'll need to amend the user resource attributes with a collector:
  ## https://puppet.com/docs/puppet/4.10/lang_resources_advanced.html#adding-or-modifying-attributes

  # Create the mining user
  user { $minebox::miner_user :
    ensure     => present,
    gid        => $minebox::miner_group,
    groups     => $minebox::miner_user_groups,
    uid        => '1050',
    managehome => true,
    home       => "/home/${minebox::miner_user}"
  }

  -> file { "/home/${minebox::miner_user}" :
    ensure => directory,
    mode   => '0774',
    owner  => $minebox::miner_user,
    group  => $minebox::miner_group,
  }

  # For now use of hiera is required to define the nvidia gpu specs on each system so we can set overclock, voltage, etc
  ###### Need to add logic around this, script output should vary based on minebox::gpu_type value
  # Create .screenrc script
  if $::minebox::gpu_type == 'nvidia' {
    file { '/home/miner/.screenrc' :
      ensure  => file,
      content => epp(
        'minebox/screenrc.epp',
        {
          'gpu_cfg' => $minebox::nv_gpus
          }
        ),
      owner   => $minebox::miner_user,
      group   => $minebox::miner_group,
      mode    => '0774',
      subscribe => File["/home/${minebox::miner_user}"],
    }
  }

  # Run screen 60 seconds after boot
  cron { 'Screen Setup' :
    ensure  => present,
    command => 'sleep 60 && /usr/bin/screen -d -m',
    user    => $minebox::miner_user,
    special => 'reboot',
  }

}
