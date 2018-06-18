# minebox::nvidia::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::install
class minebox::nvidia::install(
  Hash $nv_conf,
){
  require stdlib

  $nvidia_packages = concat($minebox::packages_xorg, $nv_conf['driver'])

  ensure_packages(
    $nvidia_packages,
    {
      ensure => present,
    }
  )

}
