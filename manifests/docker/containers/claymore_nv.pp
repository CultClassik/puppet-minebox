# minebox::docker::containers::claymore_nv
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::containers::claymore_nv { 'namevar': }
define minebox::docker::containers::claymore_nv(
  Hash $gpu,
  String $docker_image = 'cultclassik/claymore-nv',
  String $image_tag = 'latest',
)
{
  require docker
  require minebox::docker::images::claymore_nv

  $worker = "${trusted['hostname']}-${gpu['id']}"
  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => "${docker_image}:${image_tag}",
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "EWORKER=${worker}",
      "ETHACCT=${minebox::accounts['eth']}",
      "DWORKER=${trusted['hostname']}",
      "DACCT=${minebox::accounts['lbc']}",
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
