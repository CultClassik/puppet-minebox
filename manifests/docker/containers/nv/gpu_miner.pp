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
  String $miner_image,
  String $container_name,
  String $command,
  String $api_port,
  Hash $monitor,
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
      "--network=${monitor['gpu_network']}",
      ],
    command                  => $command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

  if $monitor['enable'] == true {
    docker::run { "mstatsd-${gpu_id}" :
      ensure                   => present,
      image                    => $monitor['docker_image'],
      hostname                 => "${::hostname}-msd",
      env                      => [
        "INFLUX_HOST=${monitor['influxdb']['host']}",
        "INFLUX_PORT=${monitor['influxdb']['port']}",
        "INFLUX_DB=${monitor['influxdb']['db']}",
        "INFLUX_USER=${monitor['influxdb']['user']}",
        "INFLUX_PASS=${monitor['influxdb']['pass']}",
        "MINER_HOST=${container_name}",
        "MINER_PORT=${api_port}",
        'TIMER=10000',
        ],
      volumes                  => [ '/etc/localtime:/etc/localtime' ],
      extra_parameters         => [
        '--restart on-failure:10',
        "--network=${monitor['gpu_network']}",
        ],
      remove_container_on_stop => true,
      remove_volume_on_stop    => true,
      pull_on_start            => true,
    }
  }

}
