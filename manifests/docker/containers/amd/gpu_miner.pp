# minebox::docker::containers::amd::gpu_miner
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::containers::amd::gpu_miner { 'namevar': }
define minebox::docker::containers::amd::gpu_miner(
  Integer $gpu_id,
  String $container_name,
  String $image,
  String $command,
) {

  if $image =~ /claymore/ {
    $gpu_id_new = $gpu_id ? {
      10      => 'a',
      11      => 'b',
      12      => 'c',
      13      => 'd',
      default => $gpu_id,
    }
  }

  $docker_command = regsubst($command, /GPU_ID/, "${gpu_id_new}")

  docker::run { $container_name :
    ensure                   => present,
    image                    => $image,
    hostname                 => "${::hostname}-gpu${gpu_id_new}",
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    dns                      => [ '8.8.8.8', '8.8.4.4 '],
    extra_parameters         => [ '--device=/dev/dri', '--restart on-failure:10' ],
    command                  => $docker_command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
