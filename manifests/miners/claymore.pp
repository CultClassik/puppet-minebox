# minebox::miners::claymore
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::miners::claymore
class minebox::miners::claymore (
  String $files_path,
){

  if $minebox::gpu_type == 'amd' {
    $fan_script = "${minebox::base_path}/scripts/${minebox::fan_control_script}"
  } else {
    $fan_script = "# no fan script inserted"
  }

  file { "${minebox::base_path}/claymore.sh" :
    ensure  => present,
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    mode    => '0774',
    content => epp(
      'minebox/script_claymore.epp',
      {
        'path'               => '/minebox/claymore',
        'fan_control_script' => $fan_script,
      }
    ),
  }

}
