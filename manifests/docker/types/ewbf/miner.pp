# minebox::docker::types::ewbf::miner
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::types::ewbf::miner { 'namevar': }
define minebox::docker::types::ewbf::miner(
  Hash $gpu,
) {

  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => "${gpu['d_image']}:${gpu['d_tag']}",
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "WORKER=${gpu['worker']}",
      "T_ADDR=${minebox::accounts['zcl']}",
      'POOL_SERVER=us.miningspeed.com',
      'POOL_PORT=3052',
      'POOL_PASS=x',
      'INTENSITY=64',
      'NVIDIA_DRIVER_CAPABILITIES=compute,utility',
      "NVIDIA_VISIBLE_DEVICES=${gpu['id']}",
    ],
    volumes                  => [
      '/etc/localtime:/etc/localtime',
    ],
    dns                      => ['8.8.8.8', '8.8.4.4'],
    expose                   => ['42000'],
    extra_parameters         => [
      '--runtime=nvidia',
    ],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
