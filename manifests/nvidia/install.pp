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

  #$packages = lookup('minebox::packages_xorg', {merge => 'unique'})
  #$driver = lookup('minebox::nv_conf.driver', {merge => 'deep'})
  #$nvidia_packages = concat($packages, $driver)
  $nvidia_packages = concat($nv_conf['packages'], $nv_conf['driver'])

  ensure_packages(
    $nvidia_packages,
    {
      ensure => present,
    }
  )

}
