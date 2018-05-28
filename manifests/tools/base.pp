# minebox::tools::base
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::base
class minebox::tools::base {
  include minebox::users::screen
  include minebox::users::links

  $miners_path = "${minebox::base_path}/miners"
  $tools_path = "${minebox::base_path}/tools"

  if $minebox::nv_conf['enable'] == true {
    $miners = deep_merge(lookup('minebox::miners.hybrid'), lookup('minebox::miners.nv'))
  }

  if $minebox::amd_conf['enable'] == true {
    $miners = deep_merge(lookup('minebox::miners.hybrid'), lookup('minebox::miners.amd'))
    class { 'minebox::tools::atiflash' :
      files_path => $tools_path,
    }
  }

  class { 'minebox::tools::miners' :
    files_path => $miners_path,
    miners     => $miners,
  }

  # check here, for amd only
  #file { "/home/${::minebox::miner_user}/clinfo" :
  #  ensure => link,
  #  target => '/opt/amdgpu-pro/bin/clinfo',
  #  owner  => $minebox::miner_user,
  #  group  => $minebox::miner_group,
  #  mode   => '0774',
  #}

}
