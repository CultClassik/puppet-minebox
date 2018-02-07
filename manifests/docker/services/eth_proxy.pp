# minebox::docker::services::eth_proxy
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::services::eth_proxy
class minebox::docker::services::eth_proxy(
  Boolean $enable,
  Boolean $debug,
  String $wallet,
  String $pool_host,
  String $pool_port,
  String $pool_host_failover1,
  String $pool_port_failover1,
  String $pool_host_failover2,
  String $pool_port_failover2,
  String $pool_host_failover3,
  String $pool_port_failover3,
  String $service_name,
  String $image_name,
  String $traefik_host_name,
  String $traefik_port,
  String $docker_network_web,
  Integer $swarm_replicas
  # Network to be dedicated to miner traffic:
  #String $docker_network_stratum,
) {
}
