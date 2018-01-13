# minebox::amd::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd::install
class minebox::amd::install (
  String $fan_control_script = 'amdgpu-pro-fans.sh',
) {

  include minebox::amd::driver

  file { 'AMD Fan Control Script' :
    ensure => file,
    path   => "${minebox::base_path}/scripts/${fan_control_script}",
    mode   => '0774',
    owner  => $minebox::miner_user,
    group  => $minebox::miner_group,
    source => "puppet:///modules/minebox/amd/${fan_control_script}"
  }

}
