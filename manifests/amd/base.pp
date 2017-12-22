# minebox::amd::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd::base
class minebox::amd::base {

  require apt

  include minebox::amd::install

  if $minebox::use_rocm == true {
    #include minebox::amd::rocm
    Class['::minebox::amd::install']
    #-> Class['::minebox::amd::rocm']
  }# else {
   # reboot { 'after' :
   #   subscribe => Exec['Install AMD PRO GPU Blockchain Driver'],
   # }
  #}

}
