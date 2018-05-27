# A description of what this class does
#
# @summary A short summary of the purpose of this class
# docker run --rm --hostname="miner04_msd" --network=minerstats -e "" -e   -e  -e  cryptojunkies/mstats-exp
# @example
#   include minebox::docker::containers::mstatsd
class minebox::docker::containers::mstatsd (
  String $container_name,
  String $monitor_net,
  String $image,
) {
  require minebox::docker::config

  docker::run { $container_name :
    ensure                   => present,
    image                    => $image,
    hostname                 => "${::hostname}-msd",
    env                      => [
      "INFLUX_HOST=influx_mine.diehlabs.lan",
      "INFLUX_DB=minerstats",
      "INFLUX_USER=monit0r",
      "INFLUX_PASS=monit0r",
      "MINER_HOST=${miner_host}",
      "MINER_PASS=${miner_pass}",
      ],
    volumes                  => [ '/etc/localtime:/etc/localtime' ],
    dns                      => [ '192.168.1.1' ],
    extra_parameters         => [
      '--restart on-failure:10',
      "--network=${monitor_net}",
      ],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,

  }
