# minebox::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::install
class minebox::install {
  
  contain minebox::miners::archives

  # Install required packages
  ensure_packages(
    $minebox::packages_req,
    {
      ensure => present,
    }
  )

  contain minebox::users::base
  contain minebox::miners

  Class['::minebox::users::base']
  -> Class['::minebox::miners']

  # Create the miner users local group
  -> group { $minebox::miner_group :
    ensure  => present,
    members => [ $miner_user ],
  }

  # Create the required folders
  file { $minebox::base_path :
    ensure => directory,
    group  => $minebox::miner_group,
    owner  => $minebox::miner_user,
  }

  $minebox::folders_req.each |String $folder| {
    file { "${minebox::base_path}/${folder}" :
      ensure => directory,
      owner  => $minebox::miner_user,
      group  => $minebox::miner_group,
    }
  }

  -> Class['minebox::miners']

  if $gpu_type == 'nvidia' {
    notify {'NVIDIA GPU based system!':}
    include minebox::nvidia
  }

  if $gpu_type == 'amd' {
    notify {'AMD GPU based system!':}
    include minebox::amd
  }

  class { 'python' :
    version    => 'system',
    pip        => 'latest',
    dev        => 'absent',
  }

}
