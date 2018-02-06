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
  if $swarm_mode == true {
    require docker
    contain minxbox::docker::services::eth_proxy
  }

}
