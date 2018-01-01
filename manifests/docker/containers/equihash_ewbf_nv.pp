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
  String $pool_name = 'zcl.suprnova.cc',
  String $pool_port = '4042',
  String $pool_name_1 = 'us.miningspeed.com',
  String $pool_port_1 = '3053',
)
{

  $worker = "${trusted['hostname']}_${gpu['id']}"


  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => "${docker_image}:${image_tag}",
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "WORKER=${worker}",
      "T_ADDR=${minebox::accounts['zcl']}",
      "POOL_NAME=${pool_name}",
      "POOL_PORT=${pool_port}",
      "POOL_NAME_1=${pool_name_1}",
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
