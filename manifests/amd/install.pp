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

  Class['::minebox::amd::driver']

  -> file_line { 'Enable large page support':
    path  => '/etc/default/grub',
    line => 'GRUB_CMDLINE_LINUX_DEFAULT="nomodeset amdgpu.vm_fragment_size=9"',
    #line  => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.vm_fragment_size=9"',
    match => '^GRUB_CMDLINE_LINUX_DEFAULT=.*$',
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
