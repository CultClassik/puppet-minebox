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
    #$image_name = regsubst($gpu['miner']['image'], '-', '_', 'G')

    # generate full image name from repo and image variable values
    $docker_image = "${gpu.miner.repo]}/${gpu.miner.image}"

    # generate worker id
    $worker_id = "gpu${gpu['id']}"

    # set worker id in docker command
    $command = regsubst($gpu['miner']['command'], 'WORKER_ID', $worker_id)

    # generate the container name
    $container_name = "m-${worker_id}"

    #minebox::docker::types::$image_name::miner { $container_name :
    $myres = minebox::docker::types::dstm::miner
    #minebox::docker::types::dstm::miner { $container_name :
    $myres { $container_name :
        gpu            => $gpu,
        container_name => $container_name,
        command        => $gpu['miner']['command'],
        repo           => $gpu['miner']['repo'],
        image          => $gpu['miner']['image'],
        tag            => $gpu['miner']['tag'],

    }
  }

}
