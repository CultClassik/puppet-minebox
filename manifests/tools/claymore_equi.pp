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

  if $minebox::amd_conf['enable'] == true {
    $fan_script = "#${minebox::base_path}/scripts/${minebox::fan_control_script} -s 75"
  }

  $cme_config = "-zpool us.miningspeed.com:3053 \n-zwal ${t_address}.${worker_id}\n-zpsw x"

  file { "${minebox::base_path}/miners/claymore-equi/config.txt" :
    ensure  => present,
    mode    => '0774',
    owner   => $minebox::miner_user,
    group   => $minebox::miner_group,
    content => $cme_config,
  }

  file { "${minebox::base_path}/miners/claymore-equi/start.bash" :
    ensure => absent,
  }

}
