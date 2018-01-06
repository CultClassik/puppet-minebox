# minebox::tools::claymore
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::tools::claymore
class minebox::tools::claymore_equi (
  String $files_path,
  String $t_address,
  String $worker = 'undef'
){

  if $worker == 'undef' {
    $worker_id = $facts['hostname']
  } else {
    $worker_id = $worker
  }

  unless $minebox::gpu_type == 'nvidia' {
    $fan_script = "#${minebox::base_path}/scripts/${minebox::fan_control_script} -s 75"
  }

  $cme_config = "-zpool us.miningspeed.com:3053
    -u ${t_address}.${worker_id}
    -p x
    -t 8"

  file { "${minebox::base_path}/miners/claymore-equi/config.txt" :
    ensure  => present,
    mode    => '0774',
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    content => $cme_config,
  }

}
