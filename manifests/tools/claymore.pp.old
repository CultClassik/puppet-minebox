# minebox::tools::claymore
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# NOTE - this can't accomodate hybrid nv/amd mining systems!
#
# @example
#   include minebox::tools::claymore
class minebox::tools::claymore (
  String $files_path,
){

  if $minebox::amd_conf['enable'] == true {
    $gpu_type = 'amd'
  } elsif $minebox::nv_conf['enable'] == true {
    $gpu_type = 'nvidia'
  }

  if $minebox::amd_conf['enable'] == true {
    $fan_script = "#${minebox::base_path}/scripts/${minebox::fan_control_script} -s 75"
  }

  if $minebox::claymore['platform'] == undef {
    $claymore_platform = $gpu_type ? {
      'amd'    => 1,
      'nvidia' => 2,
      default  => 3,
    }
  }
  else {
    $claymore_platform = $minebox::claymore['platform']
  }

  file { "${minebox::base_path}/scripts/claymore.sh" :
    ensure  => present,
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    mode    => '0774',
    content => epp(
      'minebox/script_claymore.epp',
      {
        'path'          => '/minebox/miners/claymore',
        'pre_mine_opts' => $fan_script,
        'eth_acct'      => $minebox::accounts['eth'],
        'lbc_acct'      => $minebox::accounts['lbc'],
        'dcri'          => $minebox::claymore['dcri'],
        'etha'          => $minebox::claymore['etha'],
        'ethi'          => $minebox::claymore['ethi'],
        'platform'      => $claymore_platform,
      }
    ),
  }

}
