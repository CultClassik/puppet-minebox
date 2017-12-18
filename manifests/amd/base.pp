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

  contain minebox::amd::base::install
  contain minebox::amd::base::config

  Class['::minebox::amd::base::install']
  -> Class['::minebox::amd::base::config']

}
