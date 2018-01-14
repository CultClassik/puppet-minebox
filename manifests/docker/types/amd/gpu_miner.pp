# minebox::docker::types::amd::gpu_miner
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::types::amd::gpu_miner { 'namevar': }
define minebox::docker::types::amd::gpu_miner(
  Integer $gpu_id,
  String $container_name,
  String $image,
  String $command,
) {

  # add the gpu id for the -di switch
  # this is necessary on amd since the container can see all of the gpus, unlike nvidia
  $docker_command = regsubst($command, 'GPU_ID', $gpu_id)

  docker::run { $container_name :
    ensure                   => present,
    image                    => $image,
    hostname                 => "${::hostname}-gpu${gpu_id}",
    env                      => [ "NVIDIA_VISIBLE_DEVICES=${gpu_id}" ],
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    dns                      => [ '8.8.8.8', '8.8.4.4 '],
    extra_parameters         => [ '--device=/dev/dri' ],
    command                  => $docker_command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
