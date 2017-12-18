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

  contain minebox::amd::install
  contain minebox::amd::config

  Class['::minebox::amd::install']
  -> Class['::minebox::amd::config']

}
