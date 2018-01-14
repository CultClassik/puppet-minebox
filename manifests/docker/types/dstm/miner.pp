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
  Hash $gpu,
  String $container_name,
  String $command,
  String $repo = 'cryptojunkies',
  String $image = 'dstm',
  String $tag = 'latest',
) {

 # I think we can make this a generic type of equihash - doesn't matter what miner we're using just pass
 # in the correct cmd to run?
 # Make sure that hostname interpolates correctly.
  #$container_name = "gpu-nv${gpu['id']}"

  docker::run { $container_name :
    ensure                   => present,
    image                    => "${repo}/${image}:${tag}",
    hostname                 => "${::trusted.hostname}-gpu${gpu['id']}",
    env                      => [ "NVIDIA_VISIBLE_DEVICES=${gpu['id']}" ],
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
