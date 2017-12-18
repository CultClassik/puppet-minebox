# minebox::miners::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::miners::config
class minebox::miners::config (

) {
  file { "${minebox::base_path}/claymore.sh" :
    ensure  => present,
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    mode    => '0774',
    content => epp(
      'cryptomine/script_claymore.epp',
      {
        'path'               => '/minebox/claymore',
        'fan_control_script' => "${minebox::base_path}/${fan_control_script}",
      }
    ),
  }

}
