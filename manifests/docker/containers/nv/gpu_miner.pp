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
      '--restart on-failure:10',
      "--network=${monitor_net}",
      ],
    command                  => $command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

  # think we need to use a var for this damn miner_port somewhere...and other stuff, this is rough and needs work
  docker::run { "mstatsd-${gpu_id}" :
    ensure                   => present,
    image                    => 'cryptojunkies/mstats-exp:latest',
    hostname                 => "${::hostname}-msd",
    env                      => [
      "INFLUX_HOST=influx_mine.diehlabs.lan",
      "INFLUX_PORT=80",
      "INFLUX_DB=minerstats",
      "INFLUX_USER=monit0r",
      "INFLUX_PASS=monit0r",
      "MINER_HOST=${container_name}",
      "MINER_PORT='3333'",
      ],
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    extra_parameters         => [
      '--restart on-failure:10',
      "--network=${monitor_net}",
      ],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}
