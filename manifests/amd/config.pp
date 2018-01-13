# minebox::amd::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
## NOTE - if miner is running and docker is set to true, the miner process has to be killed manully or we need to add a reboot after removing the screen cron job
#
# @example
#   include minebox::amd::config
class minebox::amd::config {

  $scripts_path = "${minebox::base_path}/scripts"
  $gpu_cfg = lookup('minebox::amd_conf.gpus', {merge => 'deep'})
  #$gpu_cfg = $minebox::amd_conf['gpus']
  $gpu_fan = lookup('minebox::amd_conf.gpu_fan', {merge => 'deep'})
  #$gpu_fan = $minebox::amd_conf['gpu_fan']

  if $minebox::amd_conf['use_docker'] == true {
    class { '::minebox::docker::containers::config' :
      gpus    => $gpu_cfg,
      require => Class['::minebox::users::screen'],
    }
  }

}
