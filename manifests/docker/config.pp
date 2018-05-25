# minebox::docker::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
#  Add this class to your swarm manager and set hiera values to make use of it.
#  This class needs a lot more work to be super useful.
#
# @example
#   include minebox::docker::config
class minebox::docker::config(
  Boolean $swarm_mode,
){
  require docker

  # deploy services here, may not keep this section
  #if $swarm_mode == true {
    #contain minebox::docker::services::eth_proxy
  #}

  docker_network { $minebox::gpu_monitoring_network :
    ensure  => 'present',
    driver  => 'bridge',
    options => '--attachable',
    require => Class['docker'],
  }

}
