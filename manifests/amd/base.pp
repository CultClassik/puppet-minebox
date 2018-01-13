# minebox::amd::base
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd::base
class minebox::amd::base(
  $amd_conf = lookup('minebox::amd_conf', { merge => 'deep'}),
){

  include minebox::amd::install

  class { 'minebox::amd::install' :
    amd_conf => $amd_conf,
  }

  -> class { 'minebox::amd::config' :
    amd_conf => $amd_conf,
  }

}
