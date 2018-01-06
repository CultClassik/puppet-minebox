# minebox::docker::containers::equihash_ewbf_nv
#
# Creates a NVidia Docker GPU container instance running ethminer
#
# @summary Creates a NVidia Docker GPU container instance running ethminer
#
# @example
#   minebox::docker::containers::equihash_ewbf_nv { 'namevar': }
define minebox::docker::containers::equihash_ewbf_nv(
  Hash $gpu,
  String $docker_image = 'cultclassik/equihash-ewbf-nv',
  String $image_tag = 'latest',
  String $pool_name = 'mining.miningspeed.com',
  String $pool_port = '3052',
  String $pool_name_1 = 'us.miningspeed.com',
  String $pool_port_1 = '3052',
)
{
  $t_addr = $minebox::accounts['zcl']

  notice("my_t_address: ${t_addr}")

  $worker = "${trusted['hostname']}_${gpu['id']}"

  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => "${docker_image}:${image_tag}",
    hostname                 => $worker,
    env                      => [
      "WORKER=${worker}",
      "T_ADDR=${t_addr}",
      "POOL_SERVER=${pool_name}",
      "POOL_PORT=${pool_port}",
      "POOL_SERVER_1=${pool_name_1}",
      "POOL_PORT_1=${pool_port_1}",
      'NVIDIA_DRIVER_CAPABILITIES=compute,utility',
      "NVIDIA_VISIBLE_DEVICES=${gpu['id']}",
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
