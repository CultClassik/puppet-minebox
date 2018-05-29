# minebox::docker::containers::gpu_miner
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   minebox::docker::containers::gpu_miner { 'namevar': }
define minebox::docker::containers::gpu_miner(
  Integer $gpu_id,
  String $gpu_type,
  String $miner_image,
  String $container_name,
  String $command,
  String $api_port,
  Hash $monitor,
) {
  require minebox::docker::config

   if $miner_image =~ /claymore/ {
    $gpu_id_new = $gpu_id ? {
      10      => 'a',
      11      => 'b',
      12      => 'c',
      13      => 'd',
      default => $gpu_id,
    }
  }

  $extra_params = $gpu_type ? {
    'amd'    => [ '--device=/dev/dri', '--restart on-failure:10', "--network=${monitor['gpu_network']}", ],
    'nvidia' => [ '--runtime=nvidia', '--restart on-failure:10', "--network=${monitor['gpu_network']}", ],
  }

  $env = $gpu_type ? {
    'nvidia' => [ "NVIDIA_VISIBLE_DEVICES=${gpu_id}" ],
  }

  $docker_command = regsubst($command, /GPU_ID/, "${gpu_id_new}")

  docker::run { $container_name :
    ensure                   => present,
    image                    => $miner_image,
    hostname                 => "${::hostname}-gpu${gpu_id_new}",
    env                      => $env,
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    extra_parameters         => $extra_params,
    command                  => $docker_command,
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

  if $monitor['enable'] == true {
    docker::run { "mstatsd-${gpu_id_new}" :
      ensure                   => present,
      image                    => $monitor['docker_image'],
      hostname                 => "${::hostname}-msd",
      env                      => [
        "INFLUX_HOST=${monitor['influx']['host']}",
        "INFLUX_PORT=${monitor['influx']['port']}",
        "INFLUX_DB=${monitor['influx']['db']}",
        "INFLUX_USER=${monitor['influx']['user']}",
        "INFLUX_PASS=${monitor['influx']['pass']}",
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
