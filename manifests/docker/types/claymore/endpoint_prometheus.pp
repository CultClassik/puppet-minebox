# minebox::docker::types::claymore::endpoint_prometheus
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::types::claymore::endpoint_prometheus { 'namevar': }
define minebox::docker::types::claymore::endpoint_prometheus(
) {

  docker::run { "m-nv${gpu['id']}" :
    ensure                   => present,
    image                    => 'sdelrio/claymore-exporter',
    hostname                 => "${facts['hostname']}-${gpu['id']}",
    env                      => [
      "IP=",
      "LISTENPORT=8601",
      "FREQUENCY=",
    ],
    expose                   => ['3333'],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,

  }

}
