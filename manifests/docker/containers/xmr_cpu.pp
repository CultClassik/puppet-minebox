# xmr_cpu
#
# Configures monero cpu miner Docker image.
#
# @summary This class will be depricated once we move to using the new minebox::docker::types::xmr_stak
#
# @example
#   include minebox::docker::containers::xmr_cpu

class minebox::docker::containers::xmr_cpu(
  $docker_image = 'cultclassik/cpu-xmr-stak',
  $image_tag = 'latest',
  $cpu_shares = '800',
)
{
  require docker

  docker::run { 'xmr-cpu-miner' :
    ensure                   => present,
    image                    => "${docker_image}:${image_tag}",
    env                      => [
      "WALLET_ADDRESS=${minebox::accounts['xmr']}"
      ],
    dns                      => ['8.8.8.8', '8.8.4.4'],
    extra_parameters         => [
      '--restart=always',
      '--privileged',
      "--cpu-shares=${cpu_shares}",
    ],
    volumes                  => [
      '/etc/localtime:/etc/localtime',
      '/dev/hugepages:/sys/kernel/mm/hugepages',
      ],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
