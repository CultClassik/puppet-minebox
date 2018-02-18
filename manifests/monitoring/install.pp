# minebox::monitoring::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::monitoring::install
class minebox::monitoring::install {
  class { 'monitoring':
    collectd_network_server_hostname => $::minebox::monitoring['collectd_network_server_hostname'],
  }
}
