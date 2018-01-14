# minebox::docker::types::dstm::miner
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
# NOTE! The command needs to be built in the calling class.
#
# @example
#   minebox::docker::types::dstm::miner { 'namevar': }
define minebox::docker::types::dstm::miner(
  Integer $gpu_id,
  String $container_name,
  String $image,
  String $command,
) {

  docker::run { $container_name :
    ensure                   => present,
    image                    => $image,
    hostname                 => "${::hostname}-gpu${gpu_id}",
    env                      => [ "NVIDIA_VISIBLE_DEVICES=${gpu_id}" ],
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    dns                      => [ '8.8.8.8', '8.8.4.4 '],
    expose                   => [ '2222' ],
    extra_parameters         => [ '--runtime=nvidia' ],
    command                  => $command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
