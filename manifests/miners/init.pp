# minebox::miners
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::miners
class minebox::miners {
  $files_path = "${minebox::base_path}/files"

  class { 'minebox::miners::install' :
    files_path => $files_path,
  }

}
