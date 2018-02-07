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
  String $docker_network_web,
  Integer $swarm_replicas,
  String $traefik_host_name,
  String $traefik_port,
  # Network to be dedicated to miner traffic:
  #String $docker_network_stratum,
) {

  if $enable == true {
    docker::services { $service_name :
      create       => true,
      service_name => $service_name,
      image        => $image_name,
      replicas     => $swarm_replicas,
      extra_params => [
        "--network ${docker_network_web}",
        '--label traefik.enable=true',
        "--label traefik.port=${traefik_port}",
        "--label traefik.frontend.rule=Host:${traefik_host_name}",
      ],
    }
  }
}
