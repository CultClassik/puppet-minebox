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

  $nvidia_packages = concat($minebox::packages_xorg, $minebox::nvidia_driver)

  ensure_packages(
    $nvidia_packages,
    {
      ensure => present,
    }
  )

}
