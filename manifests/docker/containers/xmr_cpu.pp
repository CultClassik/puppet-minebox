# xmr_cpu
#
# Configures monero cpu miner Docker image.
#
# @summary This class will be depricated once we move to using the new minebox::docker::types::xmr_stak
#
# @example
#   include minebox::docker::containers::xmr_cpu

class minebox::docker::containers::xmr_cpu(
  $docker_image = 'servethehome/monero_cpu_moneropool',
  $image_tag = 'latest',
  $cpu_shares = '800',
)
{
  docker::run { 'xmr-cpu-miner' :
    ensure => present,
    image  => "${docker_image}:${image_tag}",
  }

  $facts['processors']['models'].each |Integer $index, String $value| {

    docker::run { "m-cpu-${index}" :
      ensure                   => present,
      image                    => "${docker_image}:${image_tag}",
      dns                      => ['8.8.8.8', '8.8.4.4'],
      env                      => [
        "username=${minebox::accounts['xmr']}",
      ],
      extra_parameters         => [
        '--restart=always',
        "--cpu-shares=${cpu_shares}",
      ],
      volumes                  => [
        '/etc/localtime:/etc/localtime',
        '/dev/hugepages:/sys/kernel/mm/hugepages',
        ],
      remove_container_on_stop => true,
      remove_volume_on_stop    => true,
      pull_on_start            => true,
      subscribe                => Exec['Refresh mounts for Huge Pages'],
    }
  }

}
