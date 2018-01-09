# minebox::amd::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd::base
class minebox::amd::base {
  include minebox::amd::install
  include minebox::amd::config

  Class['::minebox::amd::install']
  -> Class['::minebox::amd::config']
  #if $minebox::use_rocm == true {
  #  include minebox::amd::rocm
  #  Class['::minebox::amd::install']
  #  -> Class['::minebox::amd::rocm']
  #}# else {
   # reboot { 'after' :
   #   subscribe => Exec['Install AMD PRO GPU Blockchain Driver'],
   # }
  #}

}
