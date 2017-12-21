# minebox::nvidia::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::install
class minebox::nvidia::install {

  ensure_packages(
    $minebox::packages_xorg,
    {
      ensure => present,
    }
  )

  -> package { $minebox::nvidia_driver :
    ensure => present,
  }

}
