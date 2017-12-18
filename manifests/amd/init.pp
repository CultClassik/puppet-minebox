# minebox::amd
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd
class minebox::amd {

  require apt

  contain minebox::amd::install
  contain minebox::amd::config

  Class['::minebox::amd::install']
  -> Class['::minebox::amd::config']

}
