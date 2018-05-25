# minebox::docker::containers::nv::gpu_miner
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::containers::nv::gpu_miner { 'namevar': }
define minebox::docker::containers::nv::gpu_miner(
  Integer $gpu_id,
  String $container_name,
  String $image,
  String $command,
  String $monitor_net,
) {
  require minebox::docker::config
  
  docker::run { $container_name :
    ensure                   => present,
    image                    => $image,
    hostname                 => "${::hostname}-gpu${gpu_id}",
    env                      => [ "NVIDIA_VISIBLE_DEVICES=${gpu_id}" ],
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    dns                      => [ '8.8.8.8', '8.8.4.4 '],
    extra_parameters         => [
      '--runtime=nvidia',
      '--restart on-failure:10'
      "--network=${monitor_net}"
      ],
    command                  => $command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
