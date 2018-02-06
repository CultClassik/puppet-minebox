# minebox::docker::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::config
class minebox::docker::config(
  Boolean $swarm_enable,
){
  if $swarm_enable == true {
    require docker
    contain minxbox::docker::services::eth_proxy
  }

}
