# minebox::docker::containers::ethminer_nv
#
# Creates a NVidia Docker GPU container instance running ethminer
#
# @summary Creates a NVidia Docker GPU container instance running ethminer
#
# @example
#   minebox::docker::containers::ethminer_nv { 'namevar': }
define minebox::docker::containers::ethminer_nv(
  Hash $gpu,
  String $docker_image = 'cultclassik/ethminer-nv',
  String $image_tag = 'latest',
)
{

  $worker = "${trusted['hostname']}-${gpu['id']}"

  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => "${docker_image}:${image_tag}",
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "WORKER=${worker}",
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
