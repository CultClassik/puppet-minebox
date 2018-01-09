# minebox::docker::containers::claymore_amd
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::containers::claymore_amd { 'namevar': }
define minebox::docker::containers::claymore_amd(
  Hash $gpu,
  String $docker_image = 'cultclassik/claymore-eth',
  String $image_tag = 'latest-amd',
)
{
  $worker = "${trusted['hostname']}-${gpu['id']}"

  docker::run { "m-gpu${gpu['id']}" :
    ensure                   => present,
    image                    => "${docker_image}:${image_tag}",
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "EWORKER=${worker}",
      "ETHACCT=${minebox::accounts['eth']}",
      "EWALL=${minebox::accounts['eth']}.${worker}",
      "DWORKER=${facts['hostname']}",
      "DACCT=${minebox::accounts['lbc']}",
      "DWALL=${minebox::accounts['lbc']}.${facts['hostname']}",
      "AMD_GPU_ID=${gpu['id']}",
    ],
    dns                      => ['8.8.8.8', '8.8.4.4'],
    expose                   => ['3333'],
    extra_parameters         => [
      '--device=/dev/dri',
    ],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
