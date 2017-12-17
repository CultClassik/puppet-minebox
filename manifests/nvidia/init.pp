# cryptomine::nvidia
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include cryptomine::nvidia
class cryptomine::nvidia {
  
  contain minebox::nvidia::install
  contain minebox::nvidia::config

  Class['::minebox::nvidia::install']
  -> Class['::minebox::nvidia::config']

  if $::minebox::use_docker == true {
    contain minebox::nvidia::docker
    class { '::minebox::nvidia::docker' :
      subscribe => Class['::minebox::nvidia::config'],
    }
  }
  
}
