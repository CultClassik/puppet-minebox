# cryptomine::amd
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include cryptomine::amd
class minebox::amd (
  String $fan_control_script = 'amdgpu-pro-fans.sh',
) {

  require apt

  contain minebox::amd::install
  contain minebox::amd::config

  Class['::minebox::amd::install']
  -> Class['::minebox::amd::config']

  ### need to move this to the miners manifest path
  file { "${minebox::base_path}/claymore.sh" :
    ensure  => present,
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    mode    => '0774',
    content => epp(
      'cryptomine/script_claymore.epp',
      {
        'path'               => '/minebox/claymore',
        'fan_control_script' => "${minebox::base_path}/$fan_control_script}",
      }
    ),
  }
}
