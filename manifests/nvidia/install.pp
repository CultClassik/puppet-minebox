# minebox::nvidia::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::install
class minebox::nvidia::install {

  require stdlib

  $packages = lookup('minebox::packages_xorg')
  $driver = lookup('minebox::nv_conf.driver', {merge => 'deep'})
  $nvidia_packages = concat($packages, $driver)

  ensure_packages(
    $nvidia_packages,
    {
      ensure => present,
    }
  )

}
