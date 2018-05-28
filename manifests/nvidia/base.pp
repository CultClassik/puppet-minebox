# minebox::nvidia::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::base
class minebox::nvidia::base(
  Hash $nv_conf = lookup('minebox::nv_conf', { merge => 'deep' }),
){

  class { '::minebox::nvidia::install' :
    nv_conf => $nv_conf
  }

  -> class { '::minebox::nvidia::config' :
    nv_conf => $nv_conf
  }

  if $nv_conf['use_docker'] == true {
    class { '::minebox::nvidia::docker':
      nv_conf   => $nv_conf,
      subscribe => Class['::minebox::nvidia::config'],
    }
  }

}
