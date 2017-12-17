# ethminer_nv
#
# Configures ethminer Docker image.
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::docker::containers::ethminer

class minebox::docker::containers::ethminer_nv
(
  Array $gpus = lookup('minebox::docker::containers::ethminer_nv::gpus'),
  #String $nv_drv = '384.69',
  String $docker_image = 'cultclassik/ethminer-nv',
  String $image_tag = 'latest',
  String $wallet = '0x96ae82e89ff22b3eff481e2499948c562354cb23',
)
{
  require profile::linux::docker::base
  require minebox::docker::images::ethminer_nv

  $gpus.each |$gpu| {
    $worker = "${trusted['hostname']}-${gpu['id']}"
    docker::run { "eth-nv${gpu['id']}" :
      ensure                   => present,
      image                    => "${docker_image}:${image_tag}",
      hostname                 => "${facts['hostname']}-${gpu['id']}",
      #volumes                  => [ "nvidia_driver_${nv_drv}:/usr/local/nvidia:ro"],
      env                      => ["WORKER=${worker}",
                                   "ETHACCT=${wallet}",
                                   "NVIDIA_DRIVER_CAPABILITIES=compute,utility",
                                   "NVIDIA_VISIBLE_DEVICES=${gpu['id']}",
                                  ],
      dns                      => ['8.8.8.8', '8.8.4.4'],
      expose                   => ['3333'],
      #extra_parameters         => [ '--volume-driver=nvidia-docker',
      #                        '--device=/dev/nvidiactl',
      #                        '--device=/dev/nvidia-uvm',
      #                        '--device=/dev/nvidia-uvm-tools',
      #                        "--device=/dev/nvidia${gpu['id']}",
      extra_parameters         => [
        '--runtime=nvidia',
      ],
      remove_container_on_stop => true,
      remove_volume_on_stop    => true,
      pull_on_start            => true,
    }
  }

}
