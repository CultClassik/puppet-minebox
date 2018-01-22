# minebox::users::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# If the user is managed in a linux server base profile, we'll need to amend the user resource attributes with a collector:
# https://puppet.com/docs/puppet/4.10/lang_resources_advanced.html#adding-or-modifying-attributes
#
# @example
#   include minebox::users::install
class minebox::users::install {

  #contain minebox::users::screen
  #contain minebox::users::links

  # Create the miner users local group
  group { $minebox::miner_group :
      ensure => present,
      gid    => '1050',
  }

  # Create the mining user
  -> user { $minebox::miner_user :
    ensure     => present,
    gid        => $minebox::miner_group,
    groups     => $minebox::miner_user_groups,
    uid        => '1050',
    managehome => true,
    home       => "/home/${minebox::miner_user}",
    password   => $minebox::miner_user_pwd,
    shell      => '/bin/bash',
  }

  -> file { "/home/${minebox::miner_user}" :
    ensure => directory,
    mode   => '0774',
    owner  => $minebox::miner_user,
    group  => $minebox::miner_group,
  }

  -> ssh_authorized_key { "${$minebox::miner_user}@${facts['hostname']}" :
    ensure => present,
    user   => $minebox::miner_user,
    type   => 'ssh-rsa',
    key    => $minebox::miner_user_ssh_key,
  }

  #-> class { 'minebox::users::screen' : }
  -> class { 'minebox::users::links' : }

}
