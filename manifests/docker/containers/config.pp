# minebox::docker::containers::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::containers::config
class minebox::docker::containers::config (
  Array $gpus,
) {

  notify { 'Applying Docker GPU Miner Container Class..' : }

  # merge defaults with gpu specific configs
  #$gpu_defaults = lookup('minebox::miner_defaults.nv.eth')

  $gpus.each |Hash $gpu| {
    # Replace - in image names with _
    $image_name = regsubst($gpu['miner']['image'], '(-)', '_', 'G')

    # generate full image name from repo and image variable values
    $docker_image = "${gpu['miner']['repo']}/${gpu['miner']['image']}"

    # generate the container name
    $container_name = "m-gpu${gpu['id']}"

    # set worker id in docker command

    #minebox::docker::types::$image_name::miner { $container_name :
    $myres = minebox::docker::types::dstm::miner
    #minebox::docker::types::dstm::miner { $container_name :
    $myres { $container_name :
        gpu            => $gpu,
        container_name => $container_name,
        docker_image   => $gpu['miner']['image'],
        image_tag      => $gpu['miner']['tag'],
        command        => $gpu['miner']['command'],
    }
  }

}
