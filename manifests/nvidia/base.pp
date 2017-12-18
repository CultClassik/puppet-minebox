# minebox::nvidia::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::base
class minebox::nvidia::base {

  contain minebox::nvidia::base::install
  contain minebox::nvidia::base::config

  Class['::minebox::nvidia::base::install']
  -> Class['::minebox::nvidia::base::config']

  if $::minebox::use_docker == true {
    contain minebox::nvidia::base::docker
    class { '::minebox::nvidia::base::docker' :
      subscribe => Class['::minebox::nvidia::base::config'],
    }
  }

}
