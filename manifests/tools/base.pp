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

  # class { '::archive':
  #   aws_cli_install => true,
  # }

  class { 'minebox::tools::claymore' :
    files_path => $miners_path,
  }

  class { 'minebox::tools::miners' :
    files_path => $miners_path,
  }

  class { 'minebox::tools::tools' :
    files_path => $tools_path,
  }

}
