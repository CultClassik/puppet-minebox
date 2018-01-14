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

    # generate full image name from repo and image variable values
    $docker_image = "${gpu['miner']['repo']}/${gpu['miner']['image']}:${gpu['miner']['tag']}"

    # generate worker id
    $worker_id = "gpu${gpu['id']}"

    # set worker id in docker command
    $command = regsubst($gpu['miner']['command'], 'WORKER_ID', $worker_id)

    # generate the container name
    $container_name = "m-${worker_id}"

    # need selector here to assign the value of $container_type
    $container_type = minebox::docker::types::dstm::miner

    $container_type { $container_name :
        gpu            => $gpu,
        container_name => $container_name,
        image          => $docker_image,
        command        => $gpu['miner']['command'],
    }
    #notify { "gpu-${gpu['id']}" :
    #  message => $command,
    #}
  }


}
