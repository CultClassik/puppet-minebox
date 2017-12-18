# minebox::miners::base
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::base
class minebox::miners::base {
  $files_path = "${minebox::base_path}/files"

  class { 'minebox::miners::base::install' :
    files_path => $files_path,
  }

}
