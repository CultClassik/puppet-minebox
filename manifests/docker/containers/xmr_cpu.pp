# xmr_cpu
#
# Configures monero cpu miner Docker image.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::containers::xmr_cpu

class minebox::docker::containers::xmr_cpu(
  $docker_image = 'servethehome/monero_moneropool',
  $cpu_shares = '800',
)
{
  require docker

  # Deploy image with specific tag based on CPU type
  $image_tag = $facts['processor0'] ? {
    /(Pentium|Celeron)/ => 'latest',
    /zen/               => 'zen',
    /Atom/              => 'nproc',
    default             => 'latest',
  }

  $facts['processors']['models'].each |Integer $index, String $value| {
    docker::run { "xmr-cpu-${index}" :
      ensure                   => present,
      image                    => "${docker_image}:${image_tag}",
      env                      => [ "username=${minebox::accounts['xmr']}" ],
      dns                      => ['8.8.8.8', '8.8.4.4'],
      extra_parameters         => [ '--restart=always',
                                    "--cpuset-cpus=${index}",
                                    "--cpu-shares=${cpu_shares}",
                                  ],
      remove_container_on_stop => true,
      remove_volume_on_stop    => true,
      pull_on_start            => true,
    }
  }

}
