# minebox::amd::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
## NOTE - if miner is running and docker is set to true, the miner process has to be killed manully or we need to add a reboot after removing the screen cron job
#
# @example
#   include minebox::amd::config
class minebox::amd::config(
  Hash $amd_conf,
){

  $scripts_path = "${minebox::base_path}/scripts"

  if $amd_conf['use_docker'] == true {
    class { '::minebox::docker::containers::config' :
      gpu_type => 'amd',
      gpus     => $amd_conf['gpus'],
      monitor  => lookup('minebox::monitor', {merge => 'hash'}),
      #require  => Class['::minebox::users::screen'],
    }
  }

}
