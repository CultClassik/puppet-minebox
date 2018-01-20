# minebox::tools::base
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::base
class minebox::tools::base {
  $miners_path = "${minebox::base_path}/miners"
  $tools_path = "${minebox::base_path}/tools"

  if lookup('minebox::miners.hybrid') == undef {
    $miners = {}
  } else {
    $miners = lookup('minebox::miners.hybrid')
  }

  if lookup('minebox::tools.hybrid') == undef {
    $tools = {}
  } else {
    $tools = lookup('minebox::tools.hybrid')
  }

  if $minebox::nv_conf::enable == true {
    $miners = deep_merge($miners, lookup('minebox::miners.nv'))
    $tools = deep_merge($tools, lookup('minebox::tools.nv'))
  }

  if $minebox::amd_conf::enable == true {
    $miners = deep_merge($miners, lookup('minebox::miners.amd'))
    $tools = deep_merge($tools, lookup('minebox::tools.amd'))
  }

  class { 'minebox::tools::miners' :
    files_path => $miners_path,
    miners     => $miners,
  }

  class { 'minebox::tools::tools' :
    files_path => $tools_path,
    tools      => $tools,
  }

}
