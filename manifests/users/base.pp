class minebox::users::base {

  # If the user is managed in a linux server base profile, we'll need to amend the user resource attributes with a collector:
  ## https://puppet.com/docs/puppet/4.10/lang_resources_advanced.html#adding-or-modifying-attributes

  # Create the mining user
  user { $minebox::miner_user :
    ensure => present,
    groups => $minebox::miner_user_groups,
    uid    => '1050',
  }

  # For now use of hiera is required to define the nvidia gpu specs on each system so we can set overclock, voltage, etc
  if $::minebox::gpu_type == 'nvidia' {
    file { '/home/miner/.screenrc' :
      ensure  => file,
      content => epp('cryptomine/screenrc.epp', { 'gpu_cfg' => lookup('minebox::docker::containers::ethminer_nv::gpus') }),
      owner   => $minebox::miner_user,
      group   => $minebox::miner_user,
      mode    => '0774',
    }
  }

  cron { 'Screen Setup' :
    ensure  => present,
    command => 'sleep 60 && /usr/bin/screen -d -m',
    user    => $minebox::miner_user,
    special => 'reboot',
  }

   

}
