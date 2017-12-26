# minebox::docker::types::ethminer_miner_nv
#
# Creates a NVidia Docker GPU container instance running ethminer
#
# @summary Creates a NVidia Docker GPU container instance running ethminer
#
# @example
#   minebox::docker::types::ethminer_miner_nv { 'namevar': }
define minebox::docker::types::ethminer_miner_nv(
  Hash $gpu,
)
{

  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => "${gpu['d_image']}:${gpu['d_tag']}",
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "WORKER=${gpu['worker']}",
      "ETHACCT=${minebox::accounts['eth']}",
      'NVIDIA_DRIVER_CAPABILITIES=compute,utility',
      "NVIDIA_VISIBLE_DEVICES=${gpu['id']}",
    ],
    dns                      => ['8.8.8.8', '8.8.4.4'],
    expose                   => ['3333'],
    extra_parameters         => [
      '--runtime=nvidia',
    ],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
