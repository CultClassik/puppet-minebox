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
  String $swarm_replicas,
  String $traefik_host_name,
  String $traefik_port,
  String $compose_file = '/tmp/eth-proxy.yaml',
  # Network to be dedicated to miner traffic:
  #String $docker_network_stratum,
) {

  if $enable == true {
    file { $compose_file :
      ensure  => file,
      content => epp(
        'minebox/docker/compose/eth-proxy.yaml.epp',
        {
          'wallet'              => $wallet,
          'pool_host'           => $pool_host,
          'pool_port'           => $pool_port,
          'pool_host_failover1' => $pool_host_failover1,
          'pool_port_failover1' => $pool_port_failover1,
          'pool_host_failover2' => $pool_host_failover2,
          'pool_port_failover2' => $pool_port_failover2,
          'pool_host_failover3' => $pool_host_failover3,
          'pool_port_failover3' => $pool_port_failover3,
          #'traefik_host_name'   => $traefik_host_name,
          #'traefik_port'        => $traefik_port,
          'swarm_replicas'      => $swarm_replicas,
        }
      ),
    }

    -> docker::stack { $service_name :
      ensure       => present,
      stack_name   => $service_name,
      compose_file => $compose_file,
      require      => File[$compose_file],
    }
  }

}
