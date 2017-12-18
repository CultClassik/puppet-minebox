# minebox::amd::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd::install
class minebox::amd::install {

  include minebox::amd::driver

  if $minebox::use_rocm == true {
    contain minebox::amd::rocm
  } else {
    reboot { 'after' :
      subscribe => Exec['Install AMD PRO GPU Blockchain Driver'],
    }
  }

  file { 'AMD Fan Control Script' :
    ensure => file,
    path   => "${minebox::base_path}/scripts/${fan_control_script}",
    mode   => '0774',
    owner  => $minebox::miner_user,
    group  => $minebox::miner_group,
    source => "puppet:///modules/cryptomine/amd/${fan_control_script}"
  }

}
