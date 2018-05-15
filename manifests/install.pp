# minebox::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::install
class minebox::install {

  # Install required packages
  ensure_packages(
    $minebox::packages_base,
    {
      ensure => present,
    }
  )

  # Create the required folders (base folders)
  file { $minebox::base_path :
    ensure => directory,
    group  => $minebox::miner_group,
    owner  => $minebox::miner_user,
  }

  # Create the required folders (base child folders)
  $minebox::folders.each |String $folder| {
    file { "${minebox::base_path}/${folder}" :
      ensure    => directory,
      owner     => $minebox::miner_user,
      group     => $minebox::miner_group,
      subscribe => File[$minebox::base_path],
    }
  }

  if $minebox::nv_conf['enable'] == true {
    include minebox::nvidia::base
  }

  if $minebox::amd_conf['enable'] == true {
    include minebox::amd::base
  }

}
