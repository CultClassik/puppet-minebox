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
  include minebox::amd::config

  Class['::minebox::amd::install']
  -> Class['::minebox::amd::config']

}
