# minebox::nvidia::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::base
class minebox::nvidia::base {

  include minebox::nvidia::install
  include minebox::nvidia::config

  Class['::minebox::nvidia::install']
  -> Class['::minebox::nvidia::config']

  if $minebox::nv_conf['use_docker'] == true {
    #contain minebox::nvidia::docker
    class { '::minebox::nvidia::docker':
      subscribe => Class['::minebox::nvidia::config'],
    }
  }

}
