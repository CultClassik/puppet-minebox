# cryptomine::nvidia::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include cryptomine::nvidia::install
class cryptomine::nvidia::install {

  ensure_packages(
    $minebox::packages_xorg,
    {
      ensure => present,
    }
  )

  package { $minebox::nvidia_driver :
    ensure => present,
  }

  -> if $use_docker == true {
    notify { 'Including Nvidia-Docker stuff' : }
    include minebox::nvidia::docker::docker
    include minebox::docker::containers::ethminer_nv
  }
  
}
