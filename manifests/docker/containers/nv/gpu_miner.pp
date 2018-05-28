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
  String $miner_image,
  String $command,
  String $monitor_net,
  String $monitor_image,
  String $miner_api_port,
  Hash $influxdb,
) {
  require minebox::docker::config

  docker::run { $container_name :
    ensure                   => present,
    image                    => $miner_image,
    hostname                 => "${::hostname}-gpu${gpu_id}",
    env                      => [ "NVIDIA_VISIBLE_DEVICES=${gpu_id}" ],
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
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

  if $::minebox:monitor['enable'] == true {
    docker::run { "mstatsd-${gpu_id}" :
      ensure                   => present,
      image                    => $monitor_image,
      hostname                 => "${::hostname}-msd",
      env                      => [
        "INFLUX_HOST=${influxdb['host']}",
        "INFLUX_PORT=${influxdb['port']}",
        "INFLUX_DB=${influxdb['db']}",
        "INFLUX_USER=${influxdb['user']}",
        "INFLUX_PASS=${influxdb['pass']}",
        "MINER_HOST=${container_name}",
        "MINER_PORT=${miner_api_port}",
        'TIMER=10000',
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

}
