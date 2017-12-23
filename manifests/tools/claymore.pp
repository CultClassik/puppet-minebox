# minebox::tools::claymore
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::tools::claymore
class minebox::tools::claymore (
  String $files_path,
){

  if $minebox::gpu_type == 'amd' {
    # disabled fan script for now, vars are out of whack or something, fix it asap
    $fan_script = "#${minebox::base_path}/scripts/${minebox::fan_control_script}"
  } else {
    $fan_script = '# no fan script inserted - Regards, Puppetmaster'
  }

  file { "${minebox::base_path}/scripts/claymore.sh" :
    ensure  => present,
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    mode    => '0774',
    content => epp(
      'minebox/script_claymore.epp',
      {
        'path'               => '/minebox/miners/claymore',
        'fan_control_script' => $fan_script,
        'dcri'               => $minebox::claymore_dcri,
      }
    ),
  }

}
