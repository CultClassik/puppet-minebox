# minebox::miners::base
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::base
class minebox::miners::base {
  $files_path = "${minebox::base_path}/miners"

  class { 'minebox::miners::claymore' :
    files_path => $files_path,
  }

  class { 'minebox::miners::install' :
    files_path => $files_path,
  }

}
