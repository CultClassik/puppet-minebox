# minebox::nvidia::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::base
class minebox::nvidia::base {

  contain minebox::nvidiainstall
  contain minebox::nvidiaconfig

  Class['::minebox::nvidiainstall']
  -> Class['::minebox::nvidiaconfig']

  if $::minebox::use_docker == true {
    contain minebox::nvidiadocker
    class { '::minebox::nvidiadocker' :
      subscribe => Class['::minebox::nvidiaconfig'],
    }
  }

}
